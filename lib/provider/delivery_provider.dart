//Enum to track  differnt stages of delivery process
import 'dart:async';
import 'dart:math';

import 'package:delivery_boy_app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DeliveryStatus {
  waitingForAcceptance,
  orderAccepted,
  pickingUp,
  destinationReached,
  enRoute,
  markingAsDelivered,
  delivered,
  rejected
}

class DeliveryProvider extends ChangeNotifier {
//differnt varible to store a stateDelivery
  DeliveryStatus _status = DeliveryStatus.waitingForAcceptance;
  OrderModel? _currentOrder;
  List<LatLng> _routePoints = [];
  int _currentStep = 0;
  LatLng? _currentDeliveryPosition;
  Timer? _animationTimer;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  //public getters
  DeliveryStatus get status => _status;
  OrderModel? get currentOrder => _currentOrder;
  List<LatLng> get routePoitns => _routePoints;
  int get currentStep => _currentStep;
  LatLng? get currentDeliveryPostion => _currentDeliveryPosition;
  Timer? get animationTimer => _animationTimer;
  Set<Polyline> get polylines => _polylines;
  Set<Marker> get makers => _markers;

  // sample/harcoded route points

  static const List<LatLng> _perCalculatedRoute = [
    LatLng(27.7033, 85.3066), // Starting point (Kathmandu Durbar Square)
    LatLng(27.7020, 85.3078),
    LatLng(27.7005, 85.3101),
    LatLng(27.6980, 85.3135),
    LatLng(27.6950, 85.3160),
    LatLng(27.6915, 85.3190),
    LatLng(27.6880, 85.3220),
    LatLng(27.6845, 85.3235),
    LatLng(27.6810, 85.3245),
    LatLng(27.6780, 85.3250),
    LatLng(27.6750, 85.3252),
    LatLng(27.6710, 85.3250), // End point (Patan Durbar Square)
  ];

  // a new order with demo data.
  void initialize() {
    _currentOrder = OrderModel(
        id: "ORD123",
        customerName: "Muhammed Muhsin",
        customerPhone: "+919633214025",
        item: "Tender Coconut (Normal)",
        quantity: 4,
        price: 320,
        pickupLocation: LatLng(27.7033, 85.3066),
        deliveryLocation: LatLng(27.6710, 85.3250),
        pickupAddress: "Kollam chinnakda",
        deliveryAddress: "Thaju Baith Pozhikara");
    _status = DeliveryStatus.waitingForAcceptance;
    notifyListeners(); //ui will update
  }

  //accept order and setup route;
  void acceptOrder() {
    _status = DeliveryStatus.orderAccepted;
    notifyListeners();
    // 5 sec delay before generating route and setting up map overlays
    Timer(Duration(seconds: 5), () {
      _generateRoutePoints();
      _setUpMapOverlays();

      notifyListeners();
    });
  }

  //reject order clear all data

  void rejectOrder() {
    _status = DeliveryStatus.rejected;
    _routePoints.clear();
    _polylines.clear();
    _markers.clear();
    _currentDeliveryPosition = null;
    _stopAnimatin();
    notifyListeners();
  }

  //start pickup process - Move delivery boy to pickup  location
  void startPickup() {
    _status = DeliveryStatus.pickingUp;
    _currentDeliveryPosition = _currentDeliveryPosition;
    _updateDeliveryBoyMarker();
  }

  //mark order as picked up and start delivery animation
  void markAsPickedup() {
    _status = DeliveryStatus.enRoute;
    _startDeliverySimulation();
  }

  //stop animation when destination is reached
  void markDestinationReached() {
    _status = DeliveryStatus.destinationReached;
    _stopAnimatin();
    notifyListeners();
  }

  //mark order as being delivered
  markAsDelivered() {
    _status = DeliveryStatus.markingAsDelivered;
    notifyListeners();
  }

  //complete the delivery position
  void completeDelivery() {
    _status = DeliveryStatus.delivered;
    notifyListeners();
  }

  //setup routes for pre-calculated data
  void _generateRoutePoints() {
    _routePoints = _perCalculatedRoute;
    _currentDeliveryPosition = _routePoints[0];
    _currentStep = 0;
  }

  //create polyline and marks for google maps
  void _setUpMapOverlays() {
    //route polyline
    _polylines.add(Polyline(
        polylineId: PolylineId("deliveryRoute"),
        points: _routePoints,
        color: Colors.blue,
        width: 5));

    //green marker for pickup location
    _markers.add(Marker(
        markerId: MarkerId("pickup"),
        position: _currentOrder!.pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: "Pickup location")));

    //red maker for delivery location
    _markers.add(Marker(
        markerId: MarkerId("delivery"),
        position: _currentOrder!.deliveryLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: "Delivery location")));

    //add intial delivery bor marker
    _updateDeliveryBoyMarker();
  }

  //update or create delivery boy marker with current position
  void _updateDeliveryBoyMarker() {
    _markers.removeWhere((m) => m.markerId.value == 'deliveryBoy');
    if (_currentDeliveryPosition != null) {
      _markers.add(Marker(
          markerId: MarkerId("deliveryBoy"),
          position: _currentDeliveryPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          rotation: _calculateBearing(),
          infoWindow: InfoWindow(title: "Delivery partner")));
    }
  }

  //calculate rotation angle for delivery boy marker based on movement direction
  double _calculateBearing() {
    //return 0 if at start or no route points
    if (_currentStep == 0 || _routePoints.isEmpty) return 0;
    //get previous and current position
    LatLng previousPoint = _routePoints[_currentStep - 1];
    LatLng currentPoint = _routePoints[_currentStep];
    //conver to raduns for calculations
    double lat1 = previousPoint.latitude * pi / 180;
    double lon1 = previousPoint.longitude * pi / 180;
    double lat2 = currentPoint.latitude * pi / 180;
    double lon2 = currentPoint.longitude * pi / 180;

    double y = sin(lon2 - lon1) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  //start animated movement along the route
  void _startDeliverySimulation() {
    const duration = Duration(milliseconds: 300);
    _animationTimer = Timer.periodic(duration, (timer) {
      if (_currentStep < _routePoints.length - 1) {
        _currentStep++;
        _currentDeliveryPosition = _routePoints[_currentStep];
        _updateDeliveryBoyMarker();
        notifyListeners();
      } else {
        _stopAnimatin();
        _onDestinationReached();
      }
    });
  }

  //handle when animation reached destination
  void _onDestinationReached() {
    _status = DeliveryStatus.destinationReached;
    notifyListeners();
  }

  // stop the movement animation timer
  void _stopAnimatin() {
    _animationTimer?.cancel();
    _animationTimer = null;
  }

  //reset all delivery data to initial state
  void resetDelivery() {
    _stopAnimatin();
    _status = DeliveryStatus.waitingForAcceptance;
    _routePoints = [];
    _polylines.clear();
    _markers.clear();
    _currentStep = 0;
    _currentDeliveryPosition = null;
    initialize();
    notifyListeners();
  }

  //clean up resournces when provider is disposed
  @override
  void dispose() {
    _stopAnimatin();

    super.dispose();
  }
}

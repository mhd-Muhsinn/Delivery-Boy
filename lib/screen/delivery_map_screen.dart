import 'package:delivery_boy_app/provider/delivery_provider.dart';
import 'package:delivery_boy_app/screen/app_main_screen.dart';
import 'package:delivery_boy_app/utils/colors.dart';
import 'package:delivery_boy_app/utils/image_urls.dart';
import 'package:delivery_boy_app/widgets/cutom_button.dart';
import 'package:delivery_boy_app/widgets/order_on_the_way.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({super.key});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<DeliveryProvider>(builder: (context, provider, child) {
        return Stack(
          children: [
            //google map
            _buildGoogleMap(provider),

            //order status widget layer - shows delivery progress and actions buttons
            Consumer<DeliveryProvider>(builder: (context, provider, child) {
              if (provider.currentOrder == null) return SizedBox();

              //show orederOnThe way for the delivery status execpt rejecected
              if (provider.status == DeliveryStatus.rejected) {
                return SizedBox();
              }

              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: OrderOnTheWay(
                      order: provider.currentOrder!,
                      status: provider.status,
                      onButtonPressed: () {
                        switch (provider.status) {
                          //handle button pressed based on current delivery status
                          case DeliveryStatus.pickingUp:
                            provider.markAsPickedup();
                            break;
                          case DeliveryStatus.destinationReached:
                            //when user clicks "Mark as destination reached"
                            provider.markAsDelivered();
                            break;
                          case DeliveryStatus.markingAsDelivered:
                            //when use clicks "Mark as delivered"
                            provider.completeDelivery();
                            break;
                          default:
                            break;
                        }
                      }),
                ),
              );
            }),
            if(provider.status == DeliveryStatus.delivered)
            _buildDeliveryCompletedCard(provider),
          ],
        );
      }),
    );
  }

  //delivery success overlay
  Widget _buildDeliveryCompletedCard(DeliveryProvider provider){
   return Positioned.fill(child: Container(
    color: Colors.black54,
    child: Center(
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(verfiedTickgif),fit: BoxFit.cover)
              ),

            ),
            SizedBox(height: 16),
            Text("Delivery Complete",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 8),
            Text("Great Job! Your delivery has been successfully completed.",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 14),),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(title: "Go Home",onPressed: (){
                Navigator.of(context).pop(); //close dialog
                provider.resetDelivery();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AppMainScreen()),(route)=>false);
              },),
            )

          ],
        ),
      ),
    ),
   ));
  }

  //build and configure the google map widget
  Widget _buildGoogleMap(DeliveryProvider provider) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        if (provider.currentOrder != null) {
          _moveToLocation(provider.currentOrder!.pickupLocation);
        }
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(27.7033, 85.3066), zoom: 14.0),
      markers: _buildMarkers(provider),
      polylines: _buildPolylines(provider),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
    );
  }

  //creates map markers for pickup , dleivery and delivery boy locations
  Set<Marker> _buildMarkers(DeliveryProvider provider) {
    Set<Marker> markers = {};

    if (provider.currentOrder != null) {
      //pick marker
      markers.add(Marker(
          markerId: MarkerId("pickup"),
          position: provider.currentOrder?.pickupLocation ?? LatLng(0.00, 0.00),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: "Pickup location")));

      //delivery marker
      markers.add(Marker(
          markerId: MarkerId("delivery"),
          position:
              provider.currentOrder?.deliveryLocation ?? LatLng(0.00, 0.00),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: "Delivery location")));

      //delivery boy marker when moving
      if (provider.currentDeliveryPostion != null) {
        markers.add(Marker(
            markerId: MarkerId("Delivery Boy"),
            position: provider.currentDeliveryPostion ?? LatLng(0.00, 0.00),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: "Delivery Boy")));
        //move camer to follow delivery boy
        _moveToLocation(provider.currentDeliveryPostion!);
      }
    }
    return markers;
  }

  //route line showing path between locations
  Set<Polyline> _buildPolylines(DeliveryProvider provider) {
    Set<Polyline> polylines = {};

    //show polyline when order is accepted
    if (provider.routePoitns.isNotEmpty &&
        provider.status != DeliveryStatus.waitingForAcceptance &&
        provider.status != DeliveryStatus.rejected) {
      polylines.add(Polyline(
          polylineId: PolylineId("route"),
          points: provider.routePoitns,
          color: buttonMainColor,
          width: 6));
    }
    return polylines;
  }

  //camera to specifed loaction with animation according to the marker
  void _moveToLocation(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 14));
  }
}

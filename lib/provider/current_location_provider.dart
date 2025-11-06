import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationProvider extends ChangeNotifier {
  //default: San Fransico
  LatLng _currentLocation = LatLng(37.7749, 122.4194);
  bool _isLoading = true;
  String _errorMessage = '';

  LatLng get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  CurrentLocationProvider() {
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      //check loaction persimmison is granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // request permission if denied .
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = "Location Permission denied.";
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
      //check if location service are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = "Loaction service are disable";
        _isLoading = false;
        notifyListeners();
        return;
      }
      //get current position
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);
      // Success - update location and clear loading/error states.
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      //handle any errors during location retrieval
      _errorMessage = "Error getting Location ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

  //public method to manually refresh location(can be called by UI).
  void refreshLocation() {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    _getCurrentLocation();
  }
}

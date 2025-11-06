import 'package:delivery_boy_app/provider/current_location_provider.dart';
import 'package:delivery_boy_app/utils/utils.dart';
import 'package:delivery_boy_app/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  GoogleMapController? mapController;
  bool isOnline = true;
  //callback when google map is ready
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //create markers for current location on map
  Set<Marker> _buildMarkers(LatLng currentLocation) {
    return {
      Marker(
          markerId: MarkerId(
            "current_location",
          ),
          position: currentLocation,
          infoWindow:
              InfoWindow(title: "Current Location", snippet: "You are here!"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Consumer<CurrentLocationProvider>(
            builder: (context, locationprovider, child) {
          //show loading spinner while getting location
          if (locationprovider.isLoading) {
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text("Getting your location...")
                ],
              ),
            );
          }
          //show error message after permission denied
          if (locationprovider.errorMessage.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAppSnackbar(
                  context: context,
                  type: SnackbarType.error,
                  description: locationprovider.errorMessage);
            });
          }
          return Stack(
            children: [
              //google map
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(locationprovider.currentLocation.latitude,
                        locationprovider.currentLocation.longitude)),
                        onMapCreated: _onMapCreated,
                        markers: _buildMarkers(locationprovider.currentLocation),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
              ),
              if(locationprovider.errorMessage.isEmpty)
              //show order at bottom
              Align(alignment: Alignment.bottomCenter,
              child: Padding(padding: EdgeInsets.all(15),child: OrderCard()),
              ),
              //static online at button
              Align(alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.06,
                color: Colors.white,
                child: Padding(padding: EdgeInsets.only(bottom: 8,top: 8),
                child: Center(
                  child: Align(alignment: Alignment.bottomCenter,
                child: Container(
                  width: 180,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.red,width: 2)
                  ),
                  child: Padding(padding: EdgeInsets.all(2.0),child: Row(
                    children: [
                      //online button
                      Expanded(
                        flex: 2,
                        child: 
                      Container(
                        decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: Text("Online",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                      )
                      ),
                      Expanded(child: SizedBox(

                      ))
                    ],
                  ),),
                ),  
                  ),
                ),
                
                )),
              ),

              
            ]
          );
        }));
  }
}

import 'package:delivery_boy_app/screen/driver_home_screen.dart';
import 'package:delivery_boy_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
      DriverHomeScreen(),
      Center(child: Text("Orders")),
      Center(
        child: Text("Shipmanet"),
      ),
      Center(
        child: Text("Profile"),
      )
    ];
    
    final List<IconData> _icons = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.boxOpen,  
      FontAwesomeIcons.truckFast,
      FontAwesomeIcons.solidCircleUser,
    ];
    final List<String> _labels = ["House", "Orders", "Shipment", "Profile"];
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
             bool isSelected = _currentIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: buttonSecondaryColor,
                            borderRadius: BorderRadius.circular(15))
                        : null,
                    child: Icon(
                      _icons[index],
                      size: 20,
                      color: isSelected ? buttonMainColor : Colors.black,
                    ),
                  ),
                  Text(
                    _labels[index],
                    style: TextStyle(
                        color: isSelected ? buttonMainColor : Colors.black),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

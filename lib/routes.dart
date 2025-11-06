import 'package:flutter/material.dart';

//common navigation helper
class NavigationHelper {
  //push a new screen
  static void push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  //Replace current screen
  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }
}

import 'package:delivery_boy_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
   CustomButton({super.key, required this.title, this.color = buttonMainColor,  this.textColor = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),
        ),
        
      ),
      child: Text(title,style: TextStyle(color: textColor,fontSize: 16,fontWeight: FontWeight.bold),),
    );
  }
}

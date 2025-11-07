import 'package:delivery_boy_app/models/order_model.dart';
import 'package:delivery_boy_app/provider/delivery_provider.dart';
import 'package:delivery_boy_app/utils/colors.dart';
import 'package:delivery_boy_app/widgets/cutom_button.dart';
import 'package:flutter/material.dart';

class OrderOnTheWay extends StatelessWidget {
  final OrderModel order;
  final DeliveryStatus status;
  final VoidCallback? onButtonPressed;
  const OrderOnTheWay(
      {super.key,
      required this.order,
      required this.status,
      required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.black26),
          ),

          //pickup locatin row with icon , text and phone button
          ListTile(
            leading: Icon(
              _getPickUpIcon(),
              color: _getPickupIconColor(),
            ),
            title: Text(
              "Pick Up Location",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(order.pickupAddress),
            trailing: CircleAvatar(
              radius: 18,
              backgroundColor: iconColor,
              child: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          ),

          //delivery location row with icon text and phone button

          ListTile(
            leading: Icon(_getDeliveryIcon(),color: _getDeliveryIconColor(),),
            title: Text("Delivery -${order.customerName}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
            ),
            subtitle: Text(order.deliveryAddress),
            trailing: CircleAvatar(
              radius: 18,
              backgroundColor: iconColor,child: Icon(Icons.phone,color: Colors.white,),
            ),
          ),

          Padding(padding: EdgeInsets.all(20),child: SizedBox(width: double.maxFinite,
          child: _buttonStyle(),
          ),)
        ],
      ),
    );
  }
  //returns appropirate button widget based on delivery status
  //different button type for mark as destination reached button and same button style for remaining all , only change the icon and color
  Widget _buttonStyle(){
    switch (status){
        case DeliveryStatus.destinationReached:
        //button style with arrow icon when destination reached
        return Padding(padding: EdgeInsets.symmetric(horizontal: 18),
        child: GestureDetector(
          onTap: _isButtonEnabled() ? (onButtonPressed ?? (){}): (){},
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: 
               Container(
                padding: EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: pickedUpColor.withAlpha(170),borderRadius: BorderRadius.horizontal(left: Radius.circular(30))
                ),
               child: Icon(Icons.arrow_forward,color: Colors.white),
               ),
               ),
               Expanded(
                flex: 17,
                child: 
               Container(
                padding: EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: _getButtonColor(),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(30)
                  )
                ),
                child: Center(
                  child: Text(_getButtonTitle(),style: TextStyle(
                    color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600
                  ),),
                ),
               )
               )
            ],
          ),
        ),
        );
        default: //standard button for all othe states
        return CustomButton(title: _getButtonTitle(),onPressed: _isButtonEnabled() ?(onButtonPressed ?? (){}) : (){}
        ,color: _getButtonColor(),
        );


    }
  }
 //return button color based on delivery status 
 Color _getButtonColor(){
  switch(status){
     case DeliveryStatus.pickingUp:
      return pickedUpColor;
      case DeliveryStatus.enRoute:
      return Colors.orange.withAlpha(150);
      case DeliveryStatus.destinationReached:
      return pickedUpColor;
      case DeliveryStatus.markingAsDelivered:
      return buttonMainColor;
      case DeliveryStatus.delivered:
      return Colors.red.withAlpha(150);
      default:
       return buttonMainColor;
  }
 }

  //returns button text based on delivery status
  String _getButtonTitle(){
    switch (status) {
      case DeliveryStatus.pickingUp:
      return "Mark as Picked Up";
      case DeliveryStatus.enRoute:
      return "Delivering..";
      case DeliveryStatus.destinationReached:
      return "Mark as Destination Reached";
      case DeliveryStatus.markingAsDelivered:
      return "Mark as Delivered";
      case DeliveryStatus.delivered:
      return "Marking as Delivered...";
      default:
      return "Start Pickup";
    }
  }

  //retunr whether button should be enabled/clickable
  bool _isButtonEnabled(){
     switch (status){
      case DeliveryStatus.enRoute:
      case DeliveryStatus.delivered:
      return false; //disabled during delivery animation and after final delivered 
      default:
       return true;
     }
  }


  //returen apporoproiate icon from pickup location base on status
  IconData _getPickUpIcon() {
    switch (status) {
      case DeliveryStatus.enRoute:
      case DeliveryStatus.destinationReached:
      case DeliveryStatus.markingAsDelivered:
      case DeliveryStatus.delivered:
        return Icons.check_circle; //red check icon when picked up
      default:
        return Icons.radio_button_checked;
    }
  }

  //return color for pickup icon based on status
  Color _getPickupIconColor() {
    switch (status) {
      case DeliveryStatus.enRoute:
      case DeliveryStatus.destinationReached:
      case DeliveryStatus.markingAsDelivered:
      case DeliveryStatus.delivered:
        return buttonMainColor; //red color  when picked up
      default:
        return Colors.grey;
    }
  }

  //returns appropriate icon for pickup/delivery location based on status
  IconData _getDeliveryIcon() {
    switch (status) {
      case DeliveryStatus.markingAsDelivered:
      case DeliveryStatus.delivered:
        return Icons.check_circle;
      default:
        return Icons.location_on_outlined;
    }
  }

 //return color for pickup/delivery location based on status
  Color _getDeliveryIconColor(){
     switch (status) {
      case DeliveryStatus.markingAsDelivered:
      case DeliveryStatus.delivered:
        return buttonMainColor;
      default:
        return Colors.red;
    }
  }
}

import 'package:delivery_boy_app/routes.dart';
import 'package:delivery_boy_app/utils/colors.dart';
import 'package:delivery_boy_app/utils/image_urls.dart';
import 'package:delivery_boy_app/widgets/cutom_button.dart';
import 'package:delivery_boy_app/widgets/dash_vertical_line.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
            child: Row(
              children: [
                Text("New Order Available",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(width: 15),
                Text(
                  "₹320",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: buttonMainColor),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                )
              ],
            ),
          ),
          //ordr details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // items info
                Material(
                  color: Colors.white,
                  elevation: 1,
                  shadowColor: Colors.black26,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(tenderCocoanut))),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text.rich(
                        TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                            children: [
                              TextSpan(text: "Tender Coconut (Normal)"),
                              TextSpan(
                                  text: " * 4",
                                  style: TextStyle(color: Colors.black38))
                            ]),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // pickup and delivery
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.radio_button_checked,
                          color: Colors.black54,
                          size: 28,
                        ),
                        SizedBox(
                          height: 35,
                          child: DashVerticalLine(dashheight: 5, dashWidth: 5),
                        )
                      ],
                    ),
                    SizedBox(width: 4),
                    pickUpDeliveryinfo(
                        "Pickup - ",
                        "Kollam Paravur - 1.2 km away from you",
                        "Green Valley Coconut Store")
                  ],
                ),
                //Delivery
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: buttonMainColor,
                      size: 22,
                    ),
                    SizedBox(width: 5),
                    pickUpDeliveryinfo("Delivery - ",
                        "Thaju Baith Pozhikara -3.5 km awayfrom you", "Muhsin ")
                  ],
                ),
                SizedBox(height: 15),
                //action buttons
                SizedBox(
                  width: double.maxFinite,
                  child: CustomButton(
                      title: "View Order details",
                      onPressed: () {
                        // NavigationHelper.push(context, screen);
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Expanded pickUpDeliveryinfo(title, address, subtitle) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.black38),
          )
        ],
      ),
    );
  }
}

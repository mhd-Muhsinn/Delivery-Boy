import 'dart:math';

import 'package:delivery_boy_app/provider/delivery_provider.dart';
import 'package:delivery_boy_app/utils/colors.dart';
import 'package:delivery_boy_app/utils/image_urls.dart';
import 'package:delivery_boy_app/widgets/cutom_button.dart';
import 'package:delivery_boy_app/widgets/dash_vertical_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Order Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //customer information.
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 12),
                    child: Text(
                      "Customer Information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    title: Text(
                      "Muhammed Muhsin",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Delivery * 01454535"),
                    trailing: CircleAvatar(
                      backgroundColor: iconColor,
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            // order summary
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            tenderCocoanut,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text.rich(TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(text: "Tender Coconut (Normal"),
                              TextSpan(
                                  text: " * 4",
                                  style: TextStyle(color: Colors.black38))
                            ]))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "₹320",
                          style: TextStyle(
                              fontSize: 16,
                              color: iconColor,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.check_circle_sharp, color: iconColor),
                        SizedBox(width: 10),
                        Text("Paid",
                            style: TextStyle(
                              fontSize: 16,
                              color: iconColor,
                              fontWeight: FontWeight.w600,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            //Pickup and delivery location.
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    //Pick Up address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.radio_button_checked,
                                color: Colors.black54, size: 20),
                            SizedBox(
                              height: 80,
                              child: DashVerticalLine(
                                dashheight: 5,
                                dashGap: 5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PickUp Location",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Kollam Paravur",
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(height: 2),
                            Text("Green Valley Coconut Store +919633214847 ",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey))
                          ],
                        )),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: iconColor,
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red.shade50,
                            child: Transform.rotate(
                              angle: -pi / 4,
                              child: Icon(
                                Icons.send,
                                size: 18,
                                color: buttonMainColor,
                              ),
                            ))
                      ],
                    ),

                    //Delivery address

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: buttonMainColor,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Location",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                                "Thaju Baith Pozhikara, \n Paravur 691301 , Kerala",
                                style: TextStyle(fontSize: 13)),
                            SizedBox(height: 2),
                            Text(
                              "Muhammed Muhsin",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        )),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.red.shade50,
                          child: Transform.rotate(
                            angle: -pi / 4,
                            child: Icon(
                              Icons.send,
                              size: 18,
                              color: buttonMainColor,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Consumer<DeliveryProvider>(builder: (context, provider, child) {
        return Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      color: declineOrder,
                    title: "Decline Order",
                    textColor: Colors.black54,
                    onPressed: () {},
                  )),
                  SizedBox(width: 10),
                   Expanded(
                    child: CustomButton(
                    title: "Accept Order",
                    onPressed: () {},
                  )),
                   
                ],
              ),
            ));
      }),
    );
  }
}

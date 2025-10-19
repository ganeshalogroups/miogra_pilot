import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderupdatecontroller.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/droporder.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/reachdroplocation.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/tripsummaryscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/earning_list_card_design.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// class NewTripCartDesign extends StatelessWidget {
//   final dynamic dataList;
//   final int index;
//   final bool reachedDelLocation;
//    NewTripCartDesign({super.key, required this.index, this.dataList,    required this.reachedDelLocation,});
//   OrderUpdateController orderUpdateController = Get.put(OrderUpdateController());
//    bool reachedRestaurant = false;
//   @override
//   Widget build(BuildContext context) {
//      var tripStatus = dataList[index]['tripStatus'];
//             var acceptedId = dataList[index]['acceptedById'];
//     return Container(
//     margin: EdgeInsets.all(8),
//     decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(15),
//     boxShadow: const [
//      BoxShadow(
//       color: Customcolors.deepdecorationLightGrey,
//       spreadRadius: 5,
//       blurRadius: 7,
//       offset: Offset(0, 2),
//        ),
//      ],
//     ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(ConstContentService().deliveryTypeMethod(dataList[index]["type"].toString()),
//                     style: CustomTextStyle.blackboldMediumText),
//                 Text(
//                     'Order ID : #${dataList[index]["orderDetails"]["orderCode"].toString()}',
//                     style: CustomTextStyle.orderblueAmountText),
//               ],
//             ),
//             CustomSizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                         text: 'From', style: CustomTextStyle.blackNormalText),
//                     CustomSizedBox(height: 8),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 3,
//                       child: CustomText(
//                         text:dataList[index]["pickupDetails"][0]["name"].toString(),
//                         overflow: TextOverflow.clip,
//                         style: CustomTextStyle.blackNormalText,
//                       ),
//                     ),
//                     CustomSizedBox(height: 8),
//                     CustomText(
//                       text: (dataList[index]["pickupDetails"][0]["locality"]?? ""),
//                       style: CustomTextStyle.smallGreyText,
//                     )
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                         text: 'To', style: CustomTextStyle.blackNormalText),
//                     CustomSizedBox(height: 8),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 3,
//                       child: CustomText(
//                           text: dataList[index]["deliveryDetails"][0]["name"].toString(),
//                           overflow: TextOverflow.clip,
//                           style: CustomTextStyle.blackNormalText),
//                     ),
//                     CustomSizedBox(height: 8),
//                     CustomText(
//                         text: dataList[index]["deliveryDetails"][0]["locality"]?? "", style: CustomTextStyle.smallGreyText),
//                   ],
//                 ),
//                 // CustomText(
//                 //   text: dataList[index]["orderDetails"]["deliveryType"].toString(),
//                 //   style: CustomTextStyle.redSmallText,
//                 // ),
//               ],
//             ),
//             CustomSizedBox(height: 20),
//             DottedLine(),
//              buttonMethod(  dataList[index], tripStatus, acceptedId, "restaurant"),
//             CustomSizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     CustomContainer(
//                       height: 30,
//                       borderRadius: BorderRadius.circular(10),
//                       backgroundColor: Customcolors.eEstdecorationGreen,
//                       child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                                 text: 'Est.Cost: ₹',
//                                 style: CustomTextStyle.esttext),
//                             CustomText(
//                                 text: ConstContentService().stringToDouble(dataList[index]["orderDetails"]["amountDetails"]["finalAmount"].toString()) ,
//                                 style: CustomTextStyle.esttext),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     CustomContainer(
//                       height: 30,
//                       // width:
//                       //     MediaQuery.of(context).size.width / 3.8,
//                       borderRadius: BorderRadius.circular(10),
//                       backgroundColor:  Color(0xFFFFF9E6),
//                       child: Padding(
//                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CustomText(
//                                 text: 'Distance:',
//                                 style: CustomTextStyle.distancetext),
//                             CustomText(
//                                 text: '${dataList[index]["orderDetails"]["totalKms"].toString()} km',
//                                 style: CustomTextStyle.distancetext),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     CustomContainer(
//                       height: 30,
//                       borderRadius: BorderRadius.circular(10),
//                       backgroundColor: Color(0xFFE6F5FE),
//                       child: Padding(
//                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // CustomText(
//                             //     text: 'Time: ${ConstContentService().kmToTime(dataList[index]["orderDetails"]["totalKms"].toString())}',
//                             //     style: CustomTextStyle.smallBlueText),
//                             dataList[index]["tripTime"]!=null&&dataList[index]["tripTime"].isNotEmpty?  CustomText(
//                                 text: 'Time: ${dataList[index]["tripTime"]}',
//                                 style: CustomTextStyle.timeBlueText): CustomText(
//                                 text: 'Time: 0',
//                                 style: CustomTextStyle.timeBlueText),
//                             CustomText(
//                                 text: ' mins',
//                                 style: CustomTextStyle.timeBlueText),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Icon(MdiIcons.chevronRight),
//               ],
//             ),

//           ],
//         ),
//       ),
//     );
//   }

//    Padding buttonMethod(tripData, tripStatus, acceptedId, delType) {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: CustomButton(
//           width: double.infinity,
//           borderRadius: BorderRadius.circular(20),
//           onPressed: orderUpdateController.isOrderUpdateLoading.value
//               ? null // Disable the button if loading
//               : () async {
//                   print("hhahahaha");
//                   if (switchValue == false) {
//                     _showNotification(
//                         'You are currently inactive. Activate your status to proceed.');
//                     print("deliveryman offline");
//                   } else {
//                     if (reachedRestaurant ||reachedDelLocation) {
//                       await orderUpdateController.updateReachedRestaurentStatus(
//                         tripData['_id'].toString(),
//                         DateTime.now(),
//                       );
//                     } else {
//                       setState(() {
//                         widget.reachedDelLocation == true;
//                         reachedRestaurant = true;
//                       });

//                       await orderUpdateController.updateAcceptOrderStatus(
//                         tripData['orderId'] ?? '',
//                         tripData['_id'] ?? '',
//                         UserId,
//                         DateTime.now(),
//                         tripData['totalKm'] ?? '',
//                       );

//                       if (orderUpdateController.orderErrorMessage.value ==
//                           "Trip Has Already Accepted") {
//                         Get.offAll(() =>
//                             DeliveryBottomNavigation(showBottomSheet: false));
//                       }
//                       if (tripStatus == 'accepted' && acceptedId != userId) {
//                         setState(() {
//                           reachedRestaurant =
//                               false; // Reset so text doesn't change
//                         });
//                       } else {
//                         setState(() {
//                           isAccepted = true;
//                         });
//                       }
//                     }
//                     print("deliveryman online");
//                   }
//                   // // Proceed with the regular logic if no errors
//                 },
//           child: Obx(() {
//             if (orderUpdateController.isOrderUpdateLoading.value) {
//               return SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               );
//             }

//             return Text(
//               orderUpdateController.orderErrorMessage.value ==
//                       "Trip Has Already Accepted"
//                   ? 'Accept' // Keep 'Accept' if error occurred

//                   : (tripStatus == 'accepted' && acceptedId != userId
//                       ? 'Accept'
//                       : widget.reachedDelLocation
//                           ? delType == 'restaurant'
//                               ? 'Reached Restaurant for Pickup'
//                               : 'Reached Pickup Location'
//                           : (reachedRestaurant || widget.reachedDelLocation
//                               ? delType == 'restaurant'
//                                   ? 'Reached Restaurant for Pickup'
//                                   : 'Reached Pickup Location'
//                               : 'Accept')),
//               style: CustomTextStyle.buttonText,
//             );
//           }),
//         ));
//   }

//   bool isAccepted = false;

//   void _showNotification(String message) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => CustomSnackBar(message: message),
//     );

//     // Insert the overlay entry
//     overlay.insert(overlayEntry);

//     // Remove the overlay entry after a delay
//     Future.delayed(Duration(seconds: 2), () {
//       overlayEntry.remove();
//     });
//   }
// }

class NewTripCartDesign extends StatefulWidget {
 final VoidCallback? onAccept; 
  final List dataList;
  final int index;
  final String tripStatus; // Add this parameter to pass the tripStatus
  final bool reachedDelLocation;
  final bool isAccepted;

  NewTripCartDesign({
    Key? key,
    required this.dataList,
    required this.index,
    required this.tripStatus, // Accept tripStatus here
    this.reachedDelLocation = false,
    this.isAccepted = false,
   this.onAccept,
  }) : super(key: key);

  @override
  _NewTripCartDesignState createState() => _NewTripCartDesignState();
}

class _NewTripCartDesignState extends State<NewTripCartDesign> {
  String formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '';
    try {
      final parsedDate = DateTime.parse(dateTime.toString()).toUtc().toLocal();
      return DateFormat('dd-MM-yyyy hh:mm a').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  OrderUpdateController orderUpdateController =
      Get.put(OrderUpdateController());
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Customcolors.deepdecorationLightGrey,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    ConstContentService().deliveryTypeMethod(
                        widget.dataList[widget.index]["type"].toString()),
                    style: CustomTextStyle.blackboldMediumText),
                Text(
                    'Order ID : #${widget.dataList[widget.index]["orderDetails"]["orderCode"].toString()}',
                    style: CustomTextStyle.orderblueAmountText),
              ],
            ),
            CustomSizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: 'From', style: CustomTextStyle.blackNormalText),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomText(
                        text: widget.dataList[widget.index]["pickupDetails"][0]
                                ["name"]
                            .toString(),
                        overflow: TextOverflow.clip,
                        style: CustomTextStyle.blackNormalText,
                      ),
                    ),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: CustomText(
                        maxLines: 3,
                        text: (widget.dataList[widget.index]["pickupDetails"][0]
                                ["fullAddress"] ??
                            ""),
                        style: CustomTextStyle.smallGreyTAddressext,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: 'To', style: CustomTextStyle.blackNormalText),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomText(
                        text: capitalizeFirstLetter(
                          widget.dataList[widget.index]["deliveryDetails"][0]
                                  ["name"]
                              .toString(),
                        ),
                        overflow: TextOverflow.clip,
                        style: CustomTextStyle.blackNormalText,
                      ),
                    ),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: CustomText(
                          maxLines: 3,
                          text: widget.dataList[widget.index]["deliveryDetails"]
                                  [0]["fullAddress"] ??
                              "",
                          style: CustomTextStyle.smallGreyTAddressext),
                    ),
                  ],
                ),
                // CustomText(
                //   text: dataList[index]["orderDetails"]["deliveryType"].toString(),
                //   style: CustomTextStyle.redSmallText,
                // ),
              ],
            ),
            CustomSizedBox(height: 15),
            DottedLine(),
            CustomSizedBox(height: 15),
            //  buttonMethod(  widget.dataList[widget.index], tripStatus, acceptedId, "restaurant"),
            CustomButton(
              width: double.infinity,
              borderRadius: BorderRadius.circular(20),
              onPressed: () {
                if (!switchValue) {
                  _showNotification(
                      'You are currently inactive. Activate your status to proceed.');
                } else {
                  final tripData = widget.dataList[widget.index];
                  final tripStatus = widget.tripStatus;
                  handleButtonTap(tripStatus, tripData);
                  widget.onAccept?.call();
                  print("THE BUTTON IS PRESSED");
                }
              },
              child: Text(
                getButtonText(widget.tripStatus),
                style: CustomTextStyle.buttonText,
              ),
            ),

            CustomSizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        widget.dataList[widget.index]["orderDetails"]
                                    ["paymentMethod"] ==
                                "ONLINE"
                            ? buildInfoTag(
                                label: ' ',
                                value: "Online Payment",
                                style: TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                                bgColor: Colors.green,
                              )
                            : buildInfoTag(
                                label: ' ',
                                value: "COD",
                                style: TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                                bgColor: Colors.green,
                              ),
                        const SizedBox(width: 10),
                        buildInfoTag(
                          label: 'Distance:',
                          value:
                              '${widget.dataList[widget.index]["orderDetails"]["totalKms"].toString()} km',
                          style: TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                          bgColor: const Color.fromARGB(255, 240, 212, 128)
 
                        ),
                        const SizedBox(width: 10),
                        buildInfoTag(
                          label: '',
                          value: formatDateTime(
                              widget.dataList[widget.index]["createdAt"]),
                          style:TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                          bgColor: const Color.fromARGB(255, 218, 78, 104)
                        ),
                        const SizedBox(width: 10),
                        buildInfoTag(
                          label: 'Time:',
                          value:
                              '${double.parse(widget.dataList[widget.index]["orderDetails"]["totalKms"].toString()) * 4} mins',
                          //  value: '${widget.dataList[widget.index]["tripTime"]!=null&&widget.dataList[widget.index]["tripTime"].toString().isNotEmpty ? widget.dataList[widget.index]["tripTime"] : "0"} mins',
                          style: CustomTextStyle.timeBlueText,
                          bgColor: const Color.fromARGB(255, 193, 218, 233),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                Icon(MdiIcons.chevronRight),
              ],
            )

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       children: [
            //         CustomContainer(
            //           height: 30,
            //           borderRadius: BorderRadius.circular(10),
            //           backgroundColor: Customcolors.eEstdecorationGreen,
            //           child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 CustomText(
            //                     text: 'Est.Cost: ₹',
            //                     style: CustomTextStyle.esttext),
            //                 CustomText(
            //                     text: ConstContentService().stringToDouble(widget.dataList[widget.index]["orderDetails"]["amountDetails"]["finalAmount"].toString()) ,
            //                     style: CustomTextStyle.esttext),
            //               ],
            //             ),
            //           ),
            //         ),
            //         SizedBox(width: 10),
            //         CustomContainer(
            //           height: 30,
            //           // width:
            //           //     MediaQuery.of(context).size.width / 3.8,
            //           borderRadius: BorderRadius.circular(10),
            //           backgroundColor:  Color(0xFFFFF9E6),
            //           child: Padding(
            //              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 CustomText(
            //                     text: 'Distance:',
            //                     style: CustomTextStyle.distancetext),
            //                 CustomText(
            //                     text: '${widget.dataList[widget.index]["orderDetails"]["totalKms"].toString()} km',
            //                     style: CustomTextStyle.distancetext),
            //               ],
            //             ),
            //           ),
            //         ),
            //         SizedBox(width: 10),
            //         CustomContainer(
            //           height: 30,
            //           borderRadius: BorderRadius.circular(10),
            //           backgroundColor: Color(0xFFE6F5FE),
            //           child: Padding(
            //              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 // CustomText(
            //                 //     text: 'Time: ${ConstContentService().kmToTime(dataList[index]["orderDetails"]["totalKms"].toString())}',
            //                 //     style: CustomTextStyle.smallBlueText),
            //                 widget.dataList[widget.index]["tripTime"]!=null&&widget.dataList[widget.index]["tripTime"].isNotEmpty?  CustomText(
            //                     text: 'Time: ${widget.dataList[widget.index]["tripTime"]}',
            //                     style: CustomTextStyle.timeBlueText): CustomText(
            //                     text: 'Time: 0',
            //                     style: CustomTextStyle.timeBlueText),
            //                 CustomText(
            //                     text: ' mins',
            //                     style: CustomTextStyle.timeBlueText),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Icon(MdiIcons.chevronRight),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  //  Padding buttonMethod(tripData, tripStatus, acceptedId, delType) {
  //   return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: CustomButton(
  //         width: double.infinity,
  //         borderRadius: BorderRadius.circular(20),
  //         onPressed:

  //         orderUpdateController.isOrderUpdateLoading.value
  //             ? null // Disable the button if loading
  //             : () async {
  //                 print("hhahahaha");
  //                 if (switchValue == false) {
  //                   _showNotification(
  //                       'You are currently inactive. Activate your status to proceed.');
  //                   print("deliveryman offline");
  //                 } else {
  //                   if (reachedRestaurant ||widget.reachedDelLocation) {
  //                     await orderUpdateController.updateReachedRestaurentStatus(
  //                       tripData['_id'].toString(),
  //                       DateTime.now(),
  //                     );
  //                   } else {
  //                     setState(() {
  //                       widget.reachedDelLocation == true;
  //                       reachedRestaurant = true;
  //                     });

  //                     await orderUpdateController.updateAcceptOrderStatus(
  //                       tripData['orderId'] ?? '',
  //                       tripData['_id'] ?? '',
  //                       UserId,
  //                       DateTime.now(),
  //                       tripData['totalKm'] ?? '',
  //                     );

  //                     if (orderUpdateController.orderErrorMessage.value ==
  //                         "Trip Has Already Accepted") {
  //                       Get.offAll(() =>
  //                           DeliveryBottomNavigation(showBottomSheet: false));
  //                     }
  //                     if (tripStatus == 'accepted' && acceptedId != userId) {
  //                       setState(() {
  //                         reachedRestaurant =
  //                             false; // Reset so text doesn't change
  //                       });
  //                     } else {
  //                       setState(() {
  //                         isAccepted = true;
  //                       });
  //                     }
  //                   }
  //                   print("deliveryman online");
  //                 }
  //                 // // Proceed with the regular logic if no errors
  //               },
  //         child: Obx(() {
  //           if (orderOnProcessController.isOrderOnProcessLoading.value) {
  //             return SizedBox(
  //               height: 20,
  //               width: 20,
  //               child: CircularProgressIndicator(
  //                 color: Colors.white,
  //               ),
  //             );
  //           }
  //             var orderOnProcessData =
  //                     orderOnProcessController.orderOnProcessData.value;

  //           return
  //           Text(
  //             orderUpdateController.orderErrorMessage.value ==
  //                     "Trip Has Already Accepted"
  //                 ? 'Accept' // Keep 'Accept' if error occurred

  //                 : (orderOnProcessData!["tripStatus"]== 'accepted' && acceptedId != userId
  //                     ? 'Accept'
  //                     : widget.reachedDelLocation
  //                         ? delType == 'restaurant'
  //                             ? 'Reached Restaurant for Pickup'
  //                             : 'Reached Pickup Location'
  //                         : (reachedRestaurant || widget.reachedDelLocation
  //                             ? delType == 'restaurant'
  //                                 ? 'Reached Restaurant for Pickup'
  //                                 : 'Reached Pickup Location'
  //                             : 'Accept')),
  //             style: CustomTextStyle.buttonText,
  //           );
  //         }),
  //       ));
  // }

  // bool isAccepted = false;

//   void _showNotification(String message) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => CustomSnackBar(message: message),
//     );

//     // Insert the overlay entry
//     overlay.insert(overlayEntry);

//     // Remove the overlay entry after a delay
//     Future.delayed(Duration(seconds: 2), () {
//       overlayEntry.remove();
//     });
//   }

//   String getButtonText(String tripStatus) {
//   switch (tripStatus) {
//     case 'accepted':
//       return 'Reached Restaurant for Pickup';
//     case 'reachedPickup':
//       return 'Order Picked Up';
//     case 'pickuped':
//       return 'Reached Drop Location';
//     case 'roundTripStarted':
//       return 'Reached Final Drop Location';
//     case 'reachedDelivery':
//       return 'Drop Order';
//     default:
//       return 'Start Trip';
//   }
// }

// void handleButtonTap(String tripStatus, Map<String, dynamic> tripData) {
//   switch (tripStatus) {
//     case 'accepted':
//       // showModalBottomSheet(
//       //   context: context,
//       //   builder: (_) => RestaurentBottomSheet(
//       //     deltype: tripData["type"].toString(),
//       //     orderId: tripData["orderId"].toString(),
//       //     onReachedRestaurant: () {
//       //       // Call API to update status to 'reachedPickup'
//       //       // Then refresh data
//       //     },
//       //     onBackPressed: () {
//       //       Navigator.pop(context);
//       //     },
//       //     id: tripData["_id"].toString(),
//       //     reachedDelLocation: true,
//       //   ),
//       // );
//        Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RestaurentBottomSheet(
//                               deltype:widget.dataList[widget.index]["type"]
//                                   .toString(),
//                               orderId: widget.dataList[widget.index]["orderId"]
//                                   .toString(),
//                               onReachedRestaurant: () {},
//                               onBackPressed: () {},
//                               id: widget.dataList[widget.index]["_id"].toString(),
//                               reachedDelLocation: true,
//                             ),
//                           ),
//                         );
//       break;

//     case 'reachedPickup':
//       // Get.to(() => TripSummary(
//       //       orderId: '', // If needed, add orderId
//       //       id: tripData["_id"].toString(),
//       //     ));
//       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TripSummary(
//                               orderId: '',
//                               id: widget.dataList[widget.index]["_id"].toString(),
//                             ),
//                           ),
//                         );
//       break;

//     case 'pickuped':
//       // showModalBottomSheet(
//       //   context: context,
//       //   builder: (_) => ReachDropLocationBottomSheet(
//       //     roundTrip: false,
//       //     orderId: tripData["orderId"],
//       //     id: tripData["_id"].toString(),
//       //   ),
//       // );
//       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ReachDropLocationBottomSheet(
//                               roundTrip: false,
//                               orderId: widget.dataList[widget.index]["orderId"].toString(),
//                               id: widget.dataList[widget.index]["_id"].toString(),
//                             ),
//                           ),
//                         );
//       break;

//     case 'roundTripStarted':
//       // showModalBottomSheet(
//       //   context: context,
//       //   builder: (_) => ReachDropLocationBottomSheet(
//       //     roundTrip: true,
//       //     orderId: tripData["orderId"],
//       //     id: tripData["_id"].toString(),
//       //   ),
//       // );
//       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ReachDropLocationBottomSheet(
//                               roundTrip: true,
//                               orderId: widget.dataList[widget.index]["orderId"].toString(),
//                               id: widget.dataList[widget.index]["_id"].toString(),
//                             ),
//                           ),
//                         );
//       break;

//     case 'reachedDelivery':
//       // Get.to(() => DropOrder(
//       //       id: tripData["_id"].toString(),
//       //     ));
//       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DropOrder(
//                               id: widget.dataList[widget.index]["_id"].toString(),
//                             ),
//                           ),
//                         );
//       break;

//     default:
//       // Unknown status
//       break;
//   }
// }

  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBar(message: message),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  String getButtonText(String tripStatus) {
    switch (tripStatus) {
      case 'accepted':
        return "I'm going to pick";
      case 'reachedPickup':
        return 'Picked Order';
      case 'pickuped':
        return 'Reached Delivery Location';
      // case 'roundTripStarted':
      //   return 'Reached Final Drop Location';
      case 'reachedDelivery':
        return 'Order Delivered';
      default:
        return 'Accept';
    }
  }

  Future<void> handleButtonTap(
      String tripStatus, Map<String, dynamic> tripData) async {
    if (tripStatus != 'accepted' &&
        tripStatus != 'reachedPickup' &&
        tripStatus != 'pickuped' &&
        tripStatus != 'roundTripStarted' &&
        tripStatus != 'reachedDelivery') {
      // Start Trip
      await orderUpdateController
          .updateAcceptOrderStatus(
        tripData['orderId'] ?? '',
        tripData['_id'] ?? '',
        UserId,
        DateTime.now(),
        tripData['totalKm'] ?? '',
      )
          .whenComplete(() {
        // Get.offAll(
        //     DeliveryBottomNavigation(initialIndex: 0, showBottomSheet: false));
      });

      _showNotification("Trip started successfully");

      return;
    }

    switch (tripStatus) {
      case 'accepted':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurentBottomSheet(
              deltype: widget.dataList[widget.index]["type"].toString(),
              orderId: widget.dataList[widget.index]["orderId"].toString(),
              onReachedRestaurant: () {},
              onBackPressed: () {},
              id: widget.dataList[widget.index]["_id"].toString(),
              reachedDelLocation: true,
            ),
          ),
        );
        break;

      case 'reachedPickup':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripSummary(
              orderId: '',
              id: widget.dataList[widget.index]["_id"].toString(),
            ),
          ),
        );
        break;

      case 'pickuped':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReachDropLocationBottomSheet(
              roundTrip: false,
              orderId: widget.dataList[widget.index]["orderId"].toString(),
              id: widget.dataList[widget.index]["_id"].toString(),
            ),
          ),
        );
        break;

      case 'roundTripStarted':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReachDropLocationBottomSheet(
              roundTrip: true,
              orderId: widget.dataList[widget.index]["orderId"].toString(),
              id: widget.dataList[widget.index]["_id"].toString(),
            ),
          ),
        );
        break;

      case 'reachedDelivery':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DropOrder(
              id: widget.dataList[widget.index]["_id"].toString(),
            ),
          ),
        );
        break;

      default:
        _showNotification("Unknown trip status");
        break;
    }
  }
}

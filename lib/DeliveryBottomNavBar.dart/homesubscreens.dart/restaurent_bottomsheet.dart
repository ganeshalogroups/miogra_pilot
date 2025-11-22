// ignore_for_file: avoid_print, sized_box_for_whitespace, depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderupdatecontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_tracking_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_value_controller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/earning_list_card_design.dart';
import 'package:miogra_service/Shimmer/orderdetailsshimmer.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/widgets.dart/custom_container_decoration.dart';
import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:get/get.dart';

class RestaurentBottomSheet extends StatefulWidget {
  final String id;
  final String orderId;
  final VoidCallback onReachedRestaurant;
  final bool reachedDelLocation;
  final VoidCallback onBackPressed;
  final String deltype;
  const RestaurentBottomSheet({
    super.key,
    required this.onReachedRestaurant,
    required this.onBackPressed,
    required this.id,
    required this.orderId,
    required this.reachedDelLocation,
    required this.deltype,
  });

  @override
  State<RestaurentBottomSheet> createState() => _RestaurentBottomSheetState();
}

class _RestaurentBottomSheetState extends State<RestaurentBottomSheet> {
  final NewTripsController newTripsController = Get.put(NewTripsController());
  final OrderUpdateController orderUpdateController =
      Get.put(OrderUpdateController());
  bool reachedRestaurant = false;
  final MapValueController mapValueController = Get.put(MapValueController());

  @override
  void initState() {
    super.initState();
    newTripsController.getTripsbyId(widget.id);
    print("NOTIFICATION PAGE WORKING       ${widget.id}");
    mapValueController.isAccepted(true);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   newTripsController.getTripsbyId(widget.id);
    // });
  }

  String userId = getStorage.read("UserId") ?? '';

  Future<void> _launchGoogleMapsForDirections(
      double destinationLat, double destinationLng) async {
    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps.';
    }
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await Get.off(DeliveryBottomNavigation(showBottomSheet: true));
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
                onPressed: () =>
                    Get.off(DeliveryBottomNavigation(showBottomSheet: true))),
            title: InkWell(
              onTap: () {
                print("${widget.orderId}");

                // newTripsController.getTripsbyId(widget.id);
              },
              child: Obx(() {
                if (orderUpdateController.orderErrorMessage.value.isNotEmpty) {
                  return CustomText(
                    text: 'Order Details' ,
                    style: CustomTextStyle.screenTitle,
                  );
                }
                // Determine title text based on conditions
                String titleText;
                if (widget.deltype == 'restaurant') {
                  titleText = widget.reachedDelLocation
                      ? 'Reached Restaurant      '
                      : (reachedRestaurant
                          ? 'Reached Restaurant   '
                          : 'Order Details      ');
                } else {
                  titleText = widget.reachedDelLocation
                      ? 'Reached Pickup Location      '
                      : (reachedRestaurant
                          ? 'Reached Pickup Location   '
                          : 'Order Details     ');
                }

                return CustomText(
                  text: titleText,
                  style: CustomTextStyle.screenTitle,
                );
              }),
            ),
          ),
          body: Obx(() {
            if (newTripsController.isdataLoading.value) {
              // Display the shimmer while loading
              return OrderDetailsShimmer();
            } else if (newTripsController.newTripsbyid.isEmpty) {
              return OrderDetailsShimmer();
            } else if (newTripsController.newTripsbyid == null) {
              return OrderDetailsShimmer();
            } else {
              var tripData = newTripsController.newTripsbyid.first;
              var parenAdminId = tripData['vendorAdminId'];
              print('parentid...........$parenAdminId');
              print('userid..........${tripData['']}');
              var restaurantName =
                  tripData['subAmdminDetails']?['name'] ?? 'Unknown';
              var restaurantAddress = tripData['subAmdminDetails']?['address']
                      ?['fullAddress'] ??
                  'Unknown';
              var customerName = tripData['deliveryDetails']?[0]
                      ?['contactPerson'] ??
                  'Unknown';
              var tripStatus = tripData['tripStatus'];
              var acceptedId = tripData['acceptedById'];
              var housenumb =
                  tripData['deliveryDetails']?[0]?['houseNo'] ?? 'Unknown';
              print('house $housenumb');
              var landMark =
                  tripData['deliveryDetails']?[0]?['landMark'] ?? 'Unknown';
              print('landmark $landMark');
              var customerAddress =
                  tripData['deliveryDetails']?[0]?['fullAddress'] ?? 'Unknown';
              var estCost = tripData['orderDetails']['amountDetails']
                          ['deliveryCharges']
                      ?.toString() ??
                  '';
              var triptype = tripData['orderDetails']?['deliveryType'] ?? '';
              var restImage =
                  tripData['subAmdminDetails']?['imgUrl'] ?? 'Unknown';
              var restContact =
                  tripData['subAmdminDetails']?['mobileNo'] ?? 'Unknown';
              var delType =
                  tripData['subAmdminDetails']?['subAdminType'] ?? 'Unknown';
              var pickupLatitude = double.tryParse(
                      tripData['pickupDetails']?[0]?['latitude']?.toString() ??
                          '0.0') ??
                  0.0;
              var pickupLongitude = double.tryParse(
                      tripData['pickupDetails']?[0]?['longitude']?.toString() ??
                          '0.0') ??
                  0.0;
              var totalKms = tripData['totalKm'] ?? '';
              var additionalInstructions =
                  tripData['orderDetails']["additionalInstructions"];
              var paymentmethod =
                  tripData['orderDetails']["paymentMethod"] == "ONLINE"
                      ? "Online Payment"
                      : "Cash on Delivery";
              print('dswnbdqj $totalKms');
              double totalKmsInt = double.tryParse(totalKms) ??
                  0; // Convert the string to an integer
              int tripTimeInMinutes = (totalKmsInt * 5).toInt();

              final triptime = tripData?['tripTime'];

              return Stack(children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: MapTrackingScreen(
                      tripStatus: tripData['tripStatus'],
                      restarantlocation: true,
                      orderId: tripData['orderId'],
                      isAccepted: isAccepted,
                      id: widget.id,
                      restLat: pickupLatitude,
                      restLong: pickupLongitude,
                    )),
                DraggableScrollableSheet(
                  // initialChildSize: 0.35, // starting height
                  // minChildSize: 0.2, // minimum height
                  // maxChildSize: 0.9, // maximum height
                  initialChildSize: 0.6, // Starts at 60% of screen height
                  minChildSize: 0.5, // Can't be dragged below 50%
                  maxChildSize: 0.95, // Can expand up to 95%
                  builder: (context, scrollController) {
                    return Container(
                      decoration:
                          CustomContainerDecoration.lormalPaddingDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          controller: scrollController, // important!
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Order ID: #${tripData['orderDetails']?['orderCode'] ?? 'order'} ',
                                    style: CustomTextStyle.blueAmountText,
                                  ),
                                  Spacer(),
                                  if (triptype == 'round')
                                    CustomText(
                                      text: 'Round Trip',
                                      style: CustomTextStyle.redSmallText,
                                    ),
                                ],
                              ),
                              CustomSizedBox(height: 12),
                              Text(
                                  tripData['subAmdminDetails']
                                              ?['subAdminType'] ==
                                          'restaurant'
                                      ? 'Restaurant Info'
                                      : 'Pickup Location',
                                  style: CustomTextStyle.smallGreyText),
                              CustomSizedBox(height: 12),
                              Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      delType == 'restaurant'
                                          ? CustomContainer(
                                              height: 38,
                                              width: 38,
                                              child: ClipOval(
                                                  child: Image.network(
                                                "$globalImageUrlLink${restImage}",
                                                fit: BoxFit.cover,
                                              )))
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                CustomContainer(
                                                    height: 17,
                                                    width: 17,
                                                    child: Image.asset(
                                                        'assets/images/homeicon.png',color:  Color(0xFF623089),)),
                                              ],
                                            ),
                                      SizedBox(width: 15),
                                      Container(
                                        // height:
                                        //     MediaQuery.of(context).size.height /
                                        //         15,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                delType == 'restaurant'
                                                    ? restaurantName ?? ''
                                                    : tripData['pickupDetails']
                                                            ?[0]?['name']
                                                        ?.toString(),
                                                style:
                                                    CustomTextStyle.smallText),
                                            Text(
                                              delType == 'restaurant'
                                                  ? restaurantAddress
                                                  : tripData['pickupDetails']
                                                          ?[0]?['fullAddress']
                                                      ?.toString(),
                                              style:
                                                  CustomTextStyle.smallGreyText,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await _launchGoogleMapsForDirections(
                                                    double.parse(tripData[
                                                                'pickupDetails']
                                                            [0]['latitude']
                                                        .toString()),
                                                    double.parse(tripData[
                                                                'pickupDetails']
                                                            [0]['longitude']
                                                        .toString()));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Customcolors
                                                          .darkPurple,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "View in Map",
                                                    style: CustomTextStyle
                                                        .orangetext,
                                                  ),
                                                )),
                                              ),
                                            ),
                                            // Text("Tap to open the Screen")
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final Uri url =
                                              Uri.parse('tel:$restContact');
                                          print('tel:$restContact');
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                              'assets/images/orangephone.png',color:  Color(0xFF623089),),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CustomSizedBox(height: 12),
                              Text(
                                  delType == 'restaurant'
                                      ? 'Customer Info'
                                      : 'Drop Location',
                                  style: CustomTextStyle.smallGreyText),
                              CustomSizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Container(
                                        //  color: Colors.deepOrange,

                                        height: 17,
                                        width: 17,
                                        child: Image.asset(
                                            'assets/images/homeicon.png',color: 
 Color(0xFF623089)
,),
                                      ),
                                      SizedBox(width: 17),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              capitalizeFirstLetter(
                                                  customerName),
                                              style: CustomTextStyle.smallText,
                                            ),
                                            Text(
                                              "${housenumb ?? ''}, ${landMark ?? ''}, ${customerAddress ?? ''}",
                                              //textAlign: TextAlign.center,
                                              style:
                                                  CustomTextStyle.smallGreyText,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                height: 12,
                              ),
                              paymentmethod == null || paymentmethod.isEmpty
                                  ? SizedBox()
                                  : Text("Payment Method:",
                                      style: CustomTextStyle.smallGreyText),
                              CustomSizedBox(height: 12),
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  paymentmethod == null || paymentmethod.isEmpty
                                      ? SizedBox()
                                      : Container(
                                          height: 17,
                                          width: 17,
                                          child: Image.asset(
                                              'assets/images/income.png'),
                                        ),
                                  SizedBox(width: 17),
                                  paymentmethod == null || paymentmethod.isEmpty
                                      ? SizedBox()
                                      : Text(paymentmethod.toString(),
                                          style: CustomTextStyle.smallGreyText),
                                ],
                              ),
                              CustomSizedBox(
                                height: 12,
                              ),
                              additionalInstructions == null ||
                                      additionalInstructions.isEmpty
                                  ? SizedBox()
                                  : Text("Delivery Instructions:",
                                      style: CustomTextStyle.smallGreyText),
                              CustomSizedBox(height: 12),
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  additionalInstructions == null ||
                                          additionalInstructions.isEmpty
                                      ? SizedBox()
                                      : Container(
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                            'assets/images/info.png',
                                            color:
                                                Customcolors.darkPurple,
                                          ),
                                        ),
                                  SizedBox(width: 17),
                                  additionalInstructions == null ||
                                          additionalInstructions.isEmpty
                                      ? SizedBox()
                                      : Text(
                                          additionalInstructions
                                              .toString()
                                              .capitalizeFirst
                                              .toString(),
                                          style: CustomTextStyle.smallGreyText),
                                ],
                              ),
                              CustomSizedBox(height: 12),
                              DottedLine(),
                              CustomSizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          // buildInfoTag(
                                          //   label: 'Est.Cost: ₹',
                                          //   value: double.parse(estCost).toStringAsFixed(2),
                                          //   style: CustomTextStyle.esttext,
                                          //   bgColor: Customcolors.eEstdecorationGreen,
                                          // ),
                                          // const SizedBox(width: 10),
                                          buildInfoTag(
                                            label: 'Distance:',
                                            value:
                                                '${tripData['totalKm'] ?? ''} km',
                                            style: CustomTextStyle.distancetext,
                                            bgColor: const Color(0xFFFFF9E6),
                                          ),
                                          const SizedBox(width: 10),
                                          buildInfoTag(
                                            label: 'Time:',
                                            value:
                                                '${double.parse(tripData['totalKm'].toString()) * 4} mins',
                                            //  value: '${triptime!=null&&triptime.toString().isNotEmpty?triptime.toString() : double.parse(tripData['totalKm'].toString())*4} mins',
                                            style: CustomTextStyle.timeBlueText,
                                            bgColor: const Color(0xFFE6F5FE),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(MdiIcons.chevronRight),
                                ],
                              ),
                              CustomSizedBox(height: 28),
                              buttonMethod(
                                  tripData, tripStatus, acceptedId, delType),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ]);
            }
          })),
    );
  }

  Padding buttonMethod(tripData, tripStatus, acceptedId, delType) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          width: double.infinity,
          borderRadius: BorderRadius.circular(20),
          onPressed: orderUpdateController.isOrderUpdateLoading.value
              ? null // Disable the button if loading
              : () async {
                  print("hhahahaha");
                  if (switchValue == false) {
                    _showNotification(
                        'You are currently inactive. Activate your status to proceed.');
                    print("deliveryman offline");
                  } else {
                    if (reachedRestaurant || widget.reachedDelLocation) {
                      await orderUpdateController.updateReachedRestaurentStatus(
                        tripData['_id'].toString(),
                        DateTime.now(),
                      );
                    } else {
                      setState(() {
                        widget.reachedDelLocation == true;
                        reachedRestaurant = true;
                      });

                      await orderUpdateController.updateAcceptOrderStatus(
                        tripData['orderId'] ?? '',
                        tripData['_id'] ?? '',
                        UserId,
                        DateTime.now(),
                        tripData['totalKm'] ?? '',
                      );

                      if (orderUpdateController.orderErrorMessage.value ==
                          "Trip Has Already Accepted") {
                        Get.offAll(() =>
                            DeliveryBottomNavigation(showBottomSheet: false));
                      }
                      if (tripStatus == 'accepted' && acceptedId != userId) {
                        setState(() {
                          reachedRestaurant =
                              false; // Reset so text doesn't change
                        });
                      } else {
                        setState(() {
                          isAccepted = true;
                        });
                      }
                    }
                    print("deliveryman online");
                  }
                  // // Proceed with the regular logic if no errors
                },
          child: Obx(() {
            if (orderUpdateController.isOrderUpdateLoading.value) {
              return SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            return Text(
              orderUpdateController.orderErrorMessage.value ==
                      "Trip Has Already Accepted"
                  ? 'Accept' // Keep 'Accept' if error occurred

                  : (tripStatus == 'accepted' && acceptedId != userId
                      ? 'Accept'
                      : widget.reachedDelLocation
                          ? delType == 'restaurant'
                              ? 'Reached Restaurant for Pickup'
                              : 'Reached Pickup Location'
                          : (reachedRestaurant || widget.reachedDelLocation
                              ? delType == 'restaurant'
                                  ? 'Reached Restaurant for Pickup'
                                  : 'Reached Pickup Location'
                              : 'Accept')),
              style: CustomTextStyle.buttonText,
            );
          }),
        ));
  }

  bool isAccepted = false;

  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBar(message: message),
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}



































// // ignore_for_file: avoid_print, sized_box_for_whitespace, depend_on_referenced_packages

// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Controller.dart/HomeController.dart/orderupdatecontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_tracking_screen.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_value_controller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/earning_list_card_design.dart';
// import 'package:miogra_service/Shimmer/orderdetailsshimmer.dart';
// import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
// import 'package:miogra_service/widgets.dart/custom_container_decoration.dart';
// import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:miogra_service/widgets.dart/custom_container.dart';
// import 'package:miogra_service/widgets.dart/custom_space.dart';
// import 'package:miogra_service/widgets.dart/custom_text.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:miogra_service/Const.dart/const_colors.dart';
// import 'package:get/get.dart';

// class RestaurentBottomSheet extends StatefulWidget {
//   final String id;
//   final String orderId;
//   final VoidCallback onReachedRestaurant;
//   final bool reachedDelLocation;
//   final VoidCallback onBackPressed;
//   final String deltype;
//   const RestaurentBottomSheet({
//     super.key,
//     required this.onReachedRestaurant,
//     required this.onBackPressed,
//     required this.id,
//     required this.orderId,
//     required this.reachedDelLocation,
//     required this.deltype,
//   });

//   @override
//   State<RestaurentBottomSheet> createState() => _RestaurentBottomSheetState();
// }

// class _RestaurentBottomSheetState extends State<RestaurentBottomSheet> {
//   final NewTripsController newTripsController = Get.put(NewTripsController());
//   final OrderUpdateController orderUpdateController =
//       Get.put(OrderUpdateController());
//   bool reachedRestaurant = false;
//   final MapValueController mapValueController = Get.put(MapValueController());

//   @override
//   void initState() {
//     super.initState();
//     newTripsController.getTripsbyId(widget.id);
//     print("NOTIFICATION PAGE WORKING       ${widget.id}");
//     mapValueController.isAccepted(true);
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   newTripsController.getTripsbyId(widget.id);
//     // });
//   }

//   String userId = getStorage.read("UserId") ?? '';

//   Future<void> _launchGoogleMapsForDirections(
//       double destinationLat, double destinationLng) async {
//     final googleMapsUrl =
//         'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng';
//     if (await canLaunch(googleMapsUrl)) {
//       await launch(googleMapsUrl);
//     } else {
//       throw 'Could not launch Google Maps.';
//     }
//   }

//   String capitalizeFirstLetter(String? text) {
//     if (text == null || text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) async {
//         if (didPop) return;
//         await Get.off(DeliveryBottomNavigation(showBottomSheet: true));
//       },
//       child: Scaffold(
//           appBar: AppBar(
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//             leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
//                 onPressed: () =>
//                     Get.off(DeliveryBottomNavigation(showBottomSheet: true))),
//             title: InkWell(
//               onTap: () {
//                 print("${widget.orderId}");

//                 // newTripsController.getTripsbyId(widget.id);
//               },
//               child: Obx(() {
//                 if (orderUpdateController.orderErrorMessage.value.isNotEmpty) {
//                   return CustomText(
//                     text: 'Order Details' ,
//                     style: CustomTextStyle.screenTitle,
//                   );
//                 }
//                 // Determine title text based on conditions
//                 String titleText;
//                 if (widget.deltype == 'restaurant') {
//                   titleText = widget.reachedDelLocation
//                       ? 'Reached Restaurant      '
//                       : (reachedRestaurant
//                           ? 'Reached Restaurant   '
//                           : 'Order Details      ');
//                 } else {
//                   titleText = widget.reachedDelLocation
//                       ? 'Reached Pickup Location      '
//                       : (reachedRestaurant
//                           ? 'Reached Pickup Location   '
//                           : 'Order Details     ');
//                 }

//                 return CustomText(
//                   text: titleText,
//                   style: CustomTextStyle.screenTitle,
//                 );
//               }),
//             ),
//           ),
//           body: Obx(() {
//             if (newTripsController.isdataLoading.value) {
//               // Display the shimmer while loading
//               return OrderDetailsShimmer();
//             } else if (newTripsController.newTripsbyid.isEmpty) {
//               return OrderDetailsShimmer();
//             } else if (newTripsController.newTripsbyid == null) {
//               return OrderDetailsShimmer();
//             } else {
//               var tripData = newTripsController.newTripsbyid[0]["data"][0];
//               var parenAdminId = tripData['vendorAdminId']??"";
//               print('parentid...........$parenAdminId');
//               print('userid..........${tripData['']}');
//               var restaurantName =
//                   tripData['subAmdminDetails']?['name'] ?? 'Unknown';
//               var restaurantAddress = tripData['subAmdminDetails']?['address']
//                       ?['fullAddress'] ??
//                   'Unknown';
//               var customerName = tripData['deliveryDetails']?[0]
//                       ?['contactPerson'] ??
//                   'Unknown';
//               var tripStatus = tripData['tripStatus']??"";
//               var acceptedId = tripData['acceptedById']??"";
//               var housenumb =
//                   tripData['deliveryDetails']?[0]?['houseNo'] ?? 'Unknown';
//               print('house $housenumb');
//               var landMark =
//                   tripData['deliveryDetails']?[0]?['landMark'] ?? 'Unknown';
//               print('landmark $landMark');
//               var customerAddress =
//                   tripData['deliveryDetails']?[0]?['fullAddress'] ?? 'Unknown';
//               // var estCost = tripData['orderDetails']['amountDetails']
//               //             ['deliveryCharges']
//               //         ?.toString() ??
//               //     '';
//               var triptype = tripData['orderDetails']?['deliveryType'] ?? '';
//               var restImage =
//                   tripData['subAmdminDetails']?['imgUrl'] ?? 'Unknown';
//               var restContact =
//                   tripData['subAmdminDetails']?['mobileNo'] ?? 'Unknown';
//               var delType =
//                   tripData['subAmdminDetails']?['subAdminType'] ?? 'Unknown';
//               var pickupLatitude = double.tryParse(
//                       tripData['pickupDetails']?[0]?['latitude']?.toString() ??
//                           '0.0') ??
//                   0.0;
//               var pickupLongitude = double.tryParse(
//                       tripData['pickupDetails']?[0]?['longitude']?.toString() ??
//                           '0.0') ??
//                   0.0;
//               var totalKms = tripData['totalKm'] ?? '';
//               var additionalInstructions =   "ffujfjh";
//               // tripData['orderDetails']["additionalInstructions"]??"";
       
//               var paymentmethod ="OFFLINE";
//                   // tripData['orderDetails']["paymentMethod"] == "ONLINE"
//                   //     ? "Online Payment"
//                   //     : "Cash on Delivery"??"";
//               print('dswnbdqj $totalKms');
//               double totalKmsInt = double.tryParse(totalKms) ??
//                   0; // Convert the string to an integer
//               int tripTimeInMinutes = (totalKmsInt * 5).toInt();

//               final triptime = tripData?['tripTime'];

//               return Stack(children: [
//                 SizedBox(
//                     height: MediaQuery.of(context).size.height / 1.8,
//                     child: MapTrackingScreen(
//                       tripStatus: tripData['tripStatus'],
//                       restarantlocation: true,
//                       orderId: tripData['orderId'],
//                       isAccepted: isAccepted,
//                       id: widget.id,
//                       restLat: pickupLatitude,
//                       restLong: pickupLongitude,
//                     )),
//                 DraggableScrollableSheet(
//                   // initialChildSize: 0.35, // starting height
//                   // minChildSize: 0.2, // minimum height
//                   // maxChildSize: 0.9, // maximum height
//                   initialChildSize: 0.6, // Starts at 60% of screen height
//                   minChildSize: 0.5, // Can't be dragged below 50%
//                   maxChildSize: 0.95, // Can expand up to 95%
//                   builder: (context, scrollController) {
//                     return Container(
//                       decoration:
//                           CustomContainerDecoration.lormalPaddingDecoration(),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: SingleChildScrollView(
//                           controller: scrollController, // important!
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'Order ID: #${tripData['orderDetails']?['orderCode'] ?? 'order'} ',
//                                     style: CustomTextStyle.blueAmountText,
//                                   ),
//                                   Spacer(),
//                                   if (triptype == 'round')
//                                     CustomText(
//                                       text: 'Round Trip',
//                                       style: CustomTextStyle.redSmallText,
//                                     ),
//                                 ],
//                               ),
//                               CustomSizedBox(height: 12),
//                               Text(
//                                   tripData['subAmdminDetails']
//                                               ?['subAdminType'] ==
//                                           'restaurant'
//                                       ? 'Restaurant Info'
//                                       : 'Pickup Location',
//                                   style: CustomTextStyle.smallGreyText),
//                               CustomSizedBox(height: 12),
//                               Row(
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       delType == 'restaurant'
//                                           ? CustomContainer(
//                                               height: 38,
//                                               width: 38,
//                                               child: ClipOval(
//                                                   child: Image.network(
//                                                 "$globalImageUrlLink${restImage}",
//                                                 fit: BoxFit.cover,
//                                               )))
//                                           : Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 SizedBox(
//                                                   width: 15,
//                                                 ),
//                                                 CustomContainer(
//                                                     height: 17,
//                                                     width: 17,
//                                                     child: Image.asset(
//                                                         'assets/images/homeicon.png',color:  Color(0xFF623089),)),
//                                               ],
//                                             ),
//                                       SizedBox(width: 15),
//                                       Container(
//                                         // height:
//                                         //     MediaQuery.of(context).size.height /
//                                         //         15,
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 1.8,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                                 delType == 'restaurant'
//                                                     ? restaurantName ?? ''
//                                                     : tripData['pickupDetails']
//                                                             ?[0]?['name']
//                                                         ?.toString(),
//                                                 style:
//                                                     CustomTextStyle.smallText),
//                                             Text(
//                                               delType == 'restaurant'
//                                                   ? restaurantAddress
//                                                   : tripData['pickupDetails']
//                                                           ?[0]?['fullAddress']
//                                                       ?.toString(),
//                                               style:
//                                                   CustomTextStyle.smallGreyText,
//                                             ),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             InkWell(
//                                               onTap: () async {
//                                                 await _launchGoogleMapsForDirections(
//                                                     double.parse(tripData[
//                                                                 'pickupDetails']
//                                                             [0]['latitude']
//                                                         .toString()),
//                                                     double.parse(tripData[
//                                                                 'pickupDetails']
//                                                             [0]['longitude']
//                                                         .toString()));
//                                               },
//                                               child: Container(
//                                                 margin: EdgeInsets.all(5),
//                                                 decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                       color: Customcolors
//                                                           .darkPurple,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10)),
//                                                 child: Center(
//                                                     child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     "View in Map",
//                                                     style: CustomTextStyle
//                                                         .orangetext,
//                                                   ),
//                                                 )),
//                                               ),
//                                             ),
//                                             // Text("Tap to open the Screen")
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(width: 15),
//                                   Column(
//                                     children: [
//                                       InkWell(
//                                         onTap: () async {
//                                           final Uri url =
//                                               Uri.parse('tel:$restContact');
//                                           print('tel:$restContact');
//                                           if (await canLaunchUrl(url)) {
//                                             await launchUrl(url);
//                                           } else {
//                                             throw 'Could not launch $url';
//                                           }
//                                         },
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           child: Image.asset(
//                                               'assets/images/orangephone.png',color:  Color(0xFF623089),),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 15,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               CustomSizedBox(height: 12),
//                               Text(
//                                   delType == 'restaurant'
//                                       ? 'Customer Info'
//                                       : 'Drop Location',
//                                   style: CustomTextStyle.smallGreyText),
//                               CustomSizedBox(height: 12),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       SizedBox(width: 15),
//                                       Container(
//                                         //  color: Colors.deepOrange,

//                                         height: 17,
//                                         width: 17,
//                                         child: Image.asset(
//                                             'assets/images/homeicon.png',color: 
//  Color(0xFF623089)
// ,),
//                                       ),
//                                       SizedBox(width: 17),
//                                       Container(
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 1.7,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               capitalizeFirstLetter(
//                                                   customerName),
//                                               style: CustomTextStyle.smallText,
//                                             ),
//                                             Text(
//                                               "${housenumb ?? ''}, ${landMark ?? ''}, ${customerAddress ?? ''}",
//                                               //textAlign: TextAlign.center,
//                                               style:
//                                                   CustomTextStyle.smallGreyText,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               CustomSizedBox(
//                                 height: 12,
//                               ),
//                               paymentmethod == null || paymentmethod.isEmpty
//                                   ? SizedBox()
//                                   : Text("Payment Method:",
//                                       style: CustomTextStyle.smallGreyText),
//                               CustomSizedBox(height: 12),
//                               Row(
//                                 children: [
//                                   SizedBox(width: 15),
//                                   paymentmethod == null || paymentmethod.isEmpty
//                                       ? SizedBox()
//                                       : Container(
//                                           height: 17,
//                                           width: 17,
//                                           child: Image.asset(
//                                               'assets/images/income.png'),
//                                         ),
//                                   SizedBox(width: 17),
//                                   paymentmethod == null || paymentmethod.isEmpty
//                                       ? SizedBox()
//                                       : Text(paymentmethod.toString(),
//                                           style: CustomTextStyle.smallGreyText),
//                                 ],
//                               ),
//                               CustomSizedBox(
//                                 height: 12,
//                               ),
//                               additionalInstructions == null ||
//                                       additionalInstructions.isEmpty
//                                   ? SizedBox()
//                                   : Text("Delivery Instructions:",
//                                       style: CustomTextStyle.smallGreyText),
//                               CustomSizedBox(height: 12),
//                               Row(
//                                 children: [
//                                   SizedBox(width: 15),
//                                   additionalInstructions == null ||
//                                           additionalInstructions.isEmpty
//                                       ? SizedBox()
//                                       : Container(
//                                           height: 25,
//                                           width: 25,
//                                           child: Image.asset(
//                                             'assets/images/info.png',
//                                             color:
//                                                 Customcolors.darkPurple,
//                                           ),
//                                         ),
//                                   SizedBox(width: 17),
//                                   additionalInstructions == null ||
//                                           additionalInstructions.isEmpty
//                                       ? SizedBox()
//                                       : Text(
//                                           additionalInstructions
//                                               .toString()
//                                               .capitalizeFirst
//                                               .toString(),
//                                           style: CustomTextStyle.smallGreyText),
//                                 ],
//                               ),
//                               CustomSizedBox(height: 12),
//                               DottedLine(),
//                               CustomSizedBox(
//                                 height: 12,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(
//                                         children: [
//                                           // buildInfoTag(
//                                           //   label: 'Est.Cost: ₹',
//                                           //   value: double.parse(estCost).toStringAsFixed(2),
//                                           //   style: CustomTextStyle.esttext,
//                                           //   bgColor: Customcolors.eEstdecorationGreen,
//                                           // ),
//                                           // const SizedBox(width: 10),
//                                           buildInfoTag(
//                                             label: 'Distance:',
//                                             value:
//                                                 '${tripData['totalKm'] ?? ''} km',
//                                             style: CustomTextStyle.distancetext,
//                                             bgColor: const Color(0xFFFFF9E6),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           buildInfoTag(
//                                             label: 'Time:',
//                                             value:
//                                                 '${double.parse(tripData['totalKm'].toString()) * 4} mins',
//                                             //  value: '${triptime!=null&&triptime.toString().isNotEmpty?triptime.toString() : double.parse(tripData['totalKm'].toString())*4} mins',
//                                             style: CustomTextStyle.timeBlueText,
//                                             bgColor: const Color(0xFFE6F5FE),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Icon(MdiIcons.chevronRight),
//                                 ],
//                               ),
//                               CustomSizedBox(height: 28),
//                               buttonMethod(
//                                   tripData, tripStatus, acceptedId, delType),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ]);
//             }
//           })),
//     );
//   }

//   Padding buttonMethod(tripData, tripStatus, acceptedId, delType) {
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
//                     if (reachedRestaurant || widget.reachedDelLocation) {
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

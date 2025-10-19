// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/droporder.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/reachdroplocation.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/tripsummaryscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/earning_list_card_design.dart';
import 'package:miogra_service/Shimmer/newordersshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get/get.dart';

class NewOrdersBottomSheet extends StatefulWidget {
  final LatLng? currentP;
  final bool isActive;
  final ScrollController? scrollController;

  const NewOrdersBottomSheet(
      {super.key,
      this.scrollController,
      required this.isActive,
      this.currentP});

  @override
  State<NewOrdersBottomSheet> createState() => _NewOrdersBottomSheetState();
}

class _NewOrdersBottomSheetState extends State<NewOrdersBottomSheet> {
  bool reachedRestaurant = false;

  final NewTripsController newTripsController = Get.put(NewTripsController());
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());
  final OrderOnProcessController orderOnProcessController =
      Get.put(OrderOnProcessController());

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      orderOnProcessController.orderOnProcessStatus(startdate: currentDateGlobal, enddate: currentDateGlobal);
      if (profilScreeenController.deliveryManpProfile.isNotEmpty) {
        var profileData = profilScreeenController.deliveryManpProfile.first;
        parenAdminId = profileData['parentAdminUserId'] ?? '';
      }
      newTripsController.getNewTrips();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (newTripsController.dataLoading.value) {
        Future.delayed(Duration(seconds: 2), () {
          newTripsController.isdataLoading(false);
        });

        // Display the shimmer while loading
        return Center(child: NewOrdersBottomSheetShimmer());
      }

      bool hasNewTrips = newTripsController.newTrips.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'New Trips',
              style: CustomTextStyle.stepTitleText,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                hasNewTrips
                    ? ListView.builder(
                        itemCount: newTripsController.newTrips.length,
                        itemBuilder: (context, index) {
                          var trip = newTripsController.newTrips[index];
                          var pickup = trip['pickupDetails'].first ?? {};
                          var delivery = trip['deliveryDetails'].first ?? {};
                          var orderDetails = trip['orderDetails'] ?? {};
                          var restaurentDetails =
                              trip['subAmdminDetails'] ?? {};
                          var deliveryType =
                              trip['subAmdminDetails']?['subAdminType'] ?? '';
                          print(
                              'deliveryType.............................$deliveryType');
                          var triptype = orderDetails['deliveryType'] ?? '';
                          var totalKms = trip['totalKm'] ?? '';
                          var location = delivery['locality'].toString();
                          var city = delivery['city'].toString();
                          print('locality...........${pickup['locality']}');
                          print('city...........${pickup['city']}');
                          print('name................${pickup['name']}');
                          double totalKmsInt = double.tryParse(totalKms) ??
                              0; // Convert the string to an integer
                          int tripTimeInMinutes = (totalKmsInt * 5).toInt();
                          var triptime= trip['tripTime'];

                          if (pickup == null ||
                              delivery == null ||
                              orderDetails == null) {
                            return SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                // Check if there is an ongoing order in process
                                var orderOnProcessData =
                                    orderOnProcessController
                                        .orderOnProcessData.value;

                                if (orderOnProcessData != null) {
                                  // Show a message if there's an ongoing order
                                  _showNotification(
                                      'An order is already in process. Complete it before accepting a new one.');
                                } else {
                                  if (widget.isActive) {
                                    if (widget.currentP == null) {
                                      _showNotification(
                                          'Hold on, tracking your location...');
                                    } else {
                                      // If active and no ongoing order, navigate to RestaurantBottomSheet
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RestaurentBottomSheet(
                                            onReachedRestaurant: () {},
                                            reachedDelLocation: false,
                                            deltype: deliveryType,
                                            id: trip['_id']?.toString() ?? '',
                                            orderId: trip['orderId'],
                                            onBackPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      );
                                      print('deliveryType$deliveryType');
                                    }
                                  } else {
                                    // If inactive, show a Snackbar
                                    _showNotification(
                                        'You are currently inactive. Activate your status to proceed.');
                                  }
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ConstContentService().deliveryTypeMethod(deliveryType),
                                          style: CustomTextStyle
                                              .blackboldMediumText),
                                      Text(
                                          //'Order ID : #442673'

                                          'Order ID : #${trip['orderDetails']?['orderCode']?.toString() ?? ''}',
                                          style: CustomTextStyle
                                              .orderblueAmountText),
                                    ],
                                  ),
                                  CustomSizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              text: 'From',
                                              style: CustomTextStyle
                                                  .blackNormalText),
                                          CustomSizedBox(height: 8),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: CustomText(
                                              text: deliveryType == 'restaurant'
                                                  ? restaurentDetails['name']
                                                          ?.toString() ??
                                                      ''
                                                  : pickup['name'] ?? '',
                                              overflow: TextOverflow.clip,
                                              style: CustomTextStyle
                                                  .normalMedBoldText,
                                            ),
                                          ),
                                          CustomSizedBox(height: 8),
                                          CustomText(
                                            text: (pickup['locality'] != null &&
                                                    pickup['locality']!
                                                        .isNotEmpty)
                                                ? pickup['locality']!
                                                : (pickup['city']
                                                        ?.toString()
                                                        ?.capitalizeFirst ??
                                                    ''),
                                            style:
                                                CustomTextStyle.smallGreyText,
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              text: 'To',
                                              style: CustomTextStyle
                                                  .blackNormalText),
                                          CustomSizedBox(height: 8),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: CustomText(
                                                text: delivery['contactPerson']
                                                        ?.toString() ??
                                                    '',
                                                overflow: TextOverflow.clip,
                                                style: CustomTextStyle
                                                    .normalMedBoldText),
                                          ),
                                          CustomSizedBox(height: 8),
                                          CustomText(
                                              text: location != null
                                                  ? location
                                                  : city,
                                              style: CustomTextStyle
                                                  .smallGreyText),
                                        ],
                                      ),
                                      if (triptype == 'round')
                                        CustomText(
                                          text: 'Round Trip',
                                          style: CustomTextStyle.redSmallText,
                                        ),
                                    ],
                                  ),
                                  CustomSizedBox(height: 20),
                                  DottedLine(),
                                  CustomSizedBox(height: 15),
                                       Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buildInfoTag(
              label: 'Est.Cost: ₹',
              value: double.parse(orderDetails['amountDetails']['deliveryCharges']!.toString()) .toStringAsFixed(2),
              style: CustomTextStyle.esttext,
              bgColor: Customcolors.eEstdecorationGreen,
            ),
            const SizedBox(width: 10),
            buildInfoTag(
              label: 'Distance:',
              value: '${trip['totalKm']?.toString() ?? ''} km',
              style: CustomTextStyle.distancetext,
              bgColor: const Color(0xFFFFF9E6),
            ),
            const SizedBox(width: 10),
            buildInfoTag(
              label: 'Time:',
              value: '${triptime!=null&&triptime.toString().isNotEmpty?triptime.toString() :double.parse(trip['totalKm'].toString())*4} mins',
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

         
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Row(
                                  //       children: [
                                  //         CustomContainer(
                                  //           height: 30,
                                  //           borderRadius:
                                  //               BorderRadius.circular(10),
                                  //           backgroundColor:
                                  //               Customcolors.eEstdecorationGreen,
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 CustomText(
                                  //                     text: 'Est.Cost: ₹',
                                  //                     style: CustomTextStyle
                                  //                         .esttext),
                                  //                 CustomText(
                                  //                     text: double.parse(orderDetails[
                                  //                                     'amountDetails']
                                  //                                 [
                                  //                                 'deliveryCharges']!
                                  //                             .toString())
                                  //                         .toStringAsFixed(2),
                                  //                     style: CustomTextStyle
                                  //                         .esttext),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         CustomContainer(
                                  //           height: 30,
                                  //           // width:
                                  //           //     MediaQuery.of(context).size.width / 3.8,
                                  //           borderRadius:
                                  //               BorderRadius.circular(10),
                                  //           backgroundColor:  Color(0xFFFFF9E6),
                                  //           child: Padding(
                                  //              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 CustomText(
                                  //                     text: 'Distance:',
                                  //                     style: CustomTextStyle
                                  //                         .distancetext),
                                  //                 CustomText(
                                  //                     text:
                                  //                         '${trip['totalKm']?.toString() ?? ''} km',
                                  //                     style: CustomTextStyle
                                  //                         .distancetext),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         CustomContainer(
                                  //           height: 30,
                                  //           borderRadius:
                                  //               BorderRadius.circular(10),
                                  //           backgroundColor: Color(0xFFE6F5FE),
                                  //           child: Padding(
                                  //              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 CustomText(
                                  //                     text: 'Time:',
                                  //                     style: CustomTextStyle
                                  //                         .timeBlueText),
                                  //                triptime!=null&&triptime.isNotEmpty? CustomText(
                                  //                     text:
                                  //                         '${tripTimeInMinutes.toString()} mins',
                                  //                     style: CustomTextStyle
                                  //                         .timeBlueText):CustomText(
                                  //                     text:
                                  //                         '0 mins',
                                  //                     style: CustomTextStyle
                                  //                         .timeBlueText),
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
                        },
                        controller: widget.scrollController,
                      )
                    : Center(
                        child: Text('No new trips available.',
                            style: CustomTextStyle.blueAmountText)),
                Obx(() {
                  var orderOnProcessData =
                      orderOnProcessController.orderOnProcessData.value;

                  if (orderOnProcessData == null) {
                    return Center(child: SizedBox());
                  }

                  var tripStatus = orderOnProcessData['tripStatus'];
                  var delType = orderOnProcessData['type'] ?? '';
                  var location = orderOnProcessData['deliveryDetails'][0]
                          ['locality'] ??
                      'Nagercoil';
                  var totalkm = orderOnProcessData['totalKm'] ?? '';
                  double totalAmount = double.parse("${orderOnProcessData['orderDetails']?['amountDetails']?['finalAmount']}");
                  var orderDetails = orderOnProcessData['orderDetails']
                          ?['ordersDetails'] ??
                      '1';

                  if ([
                    'accepted',
                    'reachedPickup',
                    'pickuped',
                    'reachedDelivery'
                  ].contains(tripStatus)) {
                    return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                    'assets/images/updatestatus.png'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text( ConstContentService().deliveryTypeMethod(delType),
                                  // delType == 'restaurant'
                                  //     ? 'Food Delivery'
                                  //     : 'Package',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  delType == 'restaurant'
                                      ? '${orderDetails.length ?? '1'} item | ${location ?? 'Nagercoil'}'
                                      : '1 item | ${location ?? 'Nagercoil'}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!widget.isActive) {
                                  _showNotification(
                                      'You are currently inactive. Activate your status to proceed.');
                                  return;
                                }
                                if (tripStatus == 'accepted') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurentBottomSheet(
                                        deltype: delType,
                                        orderId: orderOnProcessData['orderId'],
                                        onReachedRestaurant: () {},
                                        onBackPressed: () {},
                                        id: orderOnProcessData['_id']
                                            .toString(),
                                        reachedDelLocation: true,
                                      ),
                                    ),
                                  );
                                  print('delType $delType');
                                } else if (tripStatus == 'reachedPickup') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TripSummary(
                                          orderId: '',
                                          id: orderOnProcessData['_id']
                                              .toString()),
                                    ),
                                  );
                                } else if (tripStatus == 'pickuped') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReachDropLocationBottomSheet(
                                              roundTrip: false,
                                              orderId:orderOnProcessData['orderId'],
                                              id: orderOnProcessData['_id']
                                                  .toString()),
                                    ),
                                  );
                                } else if (tripStatus == 'roundTripStarted') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReachDropLocationBottomSheet(
                                              roundTrip: true,
                                              orderId: orderOnProcessData['orderId'],
                                              id: orderOnProcessData['_id']
                                                  .toString()),
                                    ),
                                  );
                                } else if (tripStatus == 'reachedDelivery') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DropOrder(
                                        id: orderOnProcessData['_id']
                                            .toString(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF2DC304),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              '${totalkm.toString()}Km | ₹${double.parse(totalAmount.toString()).toStringAsFixed(2)}',
                                              style: CustomTextStyle.whitetext),
                                          Text('Update Status',
                                              style:
                                                  CustomTextStyle.updateText),
                                        ],
                                      ),
                                      Icon(MdiIcons.chevronRight,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ],
            ),
          ),
        ],
      );
    });
  }


}

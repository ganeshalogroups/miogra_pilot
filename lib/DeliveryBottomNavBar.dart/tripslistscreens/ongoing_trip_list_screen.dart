import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/droporder.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/reachdroplocation.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/tripsummaryscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/empty_order_design.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/new_trip_cart_design.dart';
import 'package:miogra_service/Shimmer/newordersshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnGoingTripListScreen extends StatefulWidget {
 // final bool isActive;
  const OnGoingTripListScreen({super.key, });

  @override
  State<OnGoingTripListScreen> createState() => _OnGoingTripListScreenState();
}

class _OnGoingTripListScreenState extends State<OnGoingTripListScreen> {
  final OrderOnProcessController orderOnProcessController =
      Get.put(OrderOnProcessController());
       final NewTripsController newTripsController = Get.put(NewTripsController());

  @override
  void initState() {

      super.initState();
//      WidgetsBinding.instance.addPostFrameCallback((_)async {
//     print(TimerdataService().apiselectdateCallDate());
//     String dateCurent = TimerdataService().apiselectdateCallDate();

//  await orderOnProcessController.orderOnProcessStatus(
//         startdate: dateCurent == "null" ? currentDateGlobal : dateCurent,
//         enddate: dateCurent == "null" ? currentDateGlobal : dateCurent);

//          newTripsController.getTripsbyId(orderOnProcessController.allProgressData["data"]["data"][0]["_id"]??"");
//          });


       
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    print(TimerdataService().apiselectdateCallDate());
    String dateCurent = TimerdataService().apiselectdateCallDate();

    // ✅ FIRST API (wait)
    await orderOnProcessController.orderOnProcessStatus(
      startdate: dateCurent == "null" ? currentDateGlobal : dateCurent,
      enddate: dateCurent == "null" ? currentDateGlobal : dateCurent,
    );

    // ✅ SAFE CHECK
    final data = orderOnProcessController.allProgressData;

    if (data["data"]?["data"] != null &&
        data["data"]["data"].isNotEmpty &&
        data["data"]["data"][0]["_id"] != null) {
      
      newTripsController.getTripsbyId(
        data["data"]["data"][0]["_id"],
      );
    } else {
      
      debugPrint("No trip data found");
    }
  });
        
  
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RefreshIndicator(
          color: Customcolors.darkPurple,
        onRefresh: () async {
          await Future.delayed(
            const Duration(seconds: 2),
            () {
               WidgetsBinding.instance.addPostFrameCallback((_) {
      print(TimerdataService().apiselectdateCallDate());
    String dateCurent = TimerdataService().apiselectdateCallDate();

    orderOnProcessController.orderOnProcessStatus(
        startdate: dateCurent == "null" ? currentDateGlobal : dateCurent,
        enddate: dateCurent == "null" ? currentDateGlobal : dateCurent);
    });
            },
          );
        },
        child: Obx(() {
          if (orderOnProcessController.isOrderOnProcessLoading.value) {
            // Display the shimmer while loading
            return Center(child: NewOrdersBottomSheetShimmer());
          }else  if (newTripsController.isdataLoading.value) {
            // Display the shimmer while loading
            return Center(child: NewOrdersBottomSheetShimmer());
          }
          
           else if (orderOnProcessController.allProgressData == null ) {
            return EmptyOrderDesign(
              description: "You haven’t made any Trip yet.",
              title: "No Trips",
              img: "assets/images/no_order.png",
            );
          } else if (orderOnProcessController.allProgressData["data"].isEmpty ) {
            return EmptyOrderDesign(
              description: "You haven’t made any Trip yet.",
              title: "No Trips",
              img: "assets/images/no_order.png",
            );
          } else if (orderOnProcessController
              .allProgressData["data"]["data"].isNotEmpty  && newTripsController.newTripsbyid[0]["tripStatus"]!="cancelled") {
              //.allProgressData["data"]["data"].isNotEmpty ) {
            return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // or spaceBetween if you add more widgets
                          children: [
                            Text(
                              'Total Orders: ${orderOnProcessController.allProgressData["data"]["data"].length}',
                            style: CustomTextStyle.helloText,
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderOnProcessController
                                  .allProgressData["data"]["data"].isEmpty
                              ? 0
                              : orderOnProcessController
                                  .allProgressData["data"]["data"].length,
                          itemBuilder: (context, i) {
                            return InkWell(
                                onTap: () {
                                  // orderOnProcessController.orderOnProcessStatus();
                                  // if (!widget.isActive) {
                                  //   _showNotification(
                                  //       'You are currently inactive. Activate your status to proceed.');
                                  //   return;
                                  // }
                                  if (orderOnProcessController.allProgressData["data"]
                                              ["data"][i]["tripStatus"]
                                          .toString() ==
                                      'accepted') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurentBottomSheet(
                                          deltype: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["type"]
                                              .toString(),
                                          orderId: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["orderId"]
                                              .toString(),
                                          onReachedRestaurant: () {},
                                          onBackPressed: () {},
                                          id: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["_id"]
                                              .toString(),
                                          reachedDelLocation: true,
                                        ),
                                      ),
                                    );
                                  } else if (orderOnProcessController.allProgressData["data"]
                                              ["data"][i]["tripStatus"]
                                          .toString() ==
                                      'reachedPickup') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripSummary(
                                          orderId: '',
                                          id: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["_id"]
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  } else if (orderOnProcessController.allProgressData["data"]
                                              ["data"][i]["tripStatus"]
                                          .toString() ==
                                      'pickuped') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReachDropLocationBottomSheet(
                                          roundTrip: false,
                                          orderId: orderOnProcessController
                                                  .allProgressData["data"]["data"]
                                              [i]["orderId"],
                                          id: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["_id"]
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  } else if (orderOnProcessController
                                          .allProgressData["data"]["data"][i]
                                              ["tripStatus"]
                                          .toString() ==
                                      'roundTripStarted') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReachDropLocationBottomSheet(
                                          roundTrip: true,
                                          orderId: orderOnProcessController
                                                  .allProgressData["data"]["data"]
                                              [i]["orderId"],
                                          id: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["_id"]
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  } else if (orderOnProcessController
                                          .allProgressData["data"]["data"][i]["tripStatus"]
                                          .toString() ==
                                      'reachedDelivery') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DropOrder(
                                          id: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                                  ["_id"]
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  }
        
                                  // //    Navigator.push(
                                  // //   context,
                                  // //   MaterialPageRoute(
                                  // //     builder: (context) => RestaurentBottomSheet(
                                  // //       onReachedRestaurant: () {},
                                  // //       reachedDelLocation: true,
                                  // //       deltype: orderOnProcessController.allProgressData["data"]["data"][i]["type"].toString(),
                                  // //       id:orderOnProcessController.allProgressData["data"]["data"][i]["_id"].toString(),
                                  // //       orderId: orderOnProcessController.allProgressData["data"]["data"][i]["orderId"].toString(),
                                  // //       onBackPressed: () {
                                  // //         Navigator.pop(context);
                                  // //       },
                                  // //     ),
                                  // //   ),
                                  // // );
                                },
                                //  child:     Text(orderOnProcessController.allProgressData["data"]["data"][i]["type"]
                                //                     .toString()),
                                child: NewTripCartDesign(
                                  dataList: orderOnProcessController
                                      .allProgressData["data"]["data"],
                                  index: i,
                                  tripStatus: orderOnProcessController
                                          .allProgressData["data"]["data"][i]
                                      ["tripStatus"],
                                  reachedDelLocation: true,
                                  isAccepted: orderOnProcessController
                                              .allProgressData["data"]["data"][i]
                                          ["tripStatus"] ==
                                      "accepted", // Optional
                                )
        
                                //  NewTripCartDesign(
                                //           id: orderOnProcessController.allProgressData["data"]
                                //                   ["data"][i]["_id"]
                                //               .toString(),
                                //   index: i,
                                //   dataList: orderOnProcessController.allProgressData["data"]
                                //       ["data"], reachedDelLocation: true,
                                // ),
                                );
                          }),
                    ],
                  ),
                ));
          } else {
            return EmptyOrderDesign(
              description: "You haven’t made any Trip yet.",
              title: "No Trips",
              img: "assets/images/no_order.png",
            );
          }
        }),
      ),
    );
  }
}

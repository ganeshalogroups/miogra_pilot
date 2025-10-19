import 'dart:async';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/tripsummaryscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/empty_order_design.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/new_trip_cart_design.dart';
import 'package:miogra_service/Shimmer/newordersshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTripScreen extends StatefulWidget {
  final VoidCallback onAccept;
  const NewTripScreen({super.key, required this.onAccept});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final NewTripsController newTripsController = Get.put(NewTripsController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 0), () {
        print(TimerdataService().apiselectdateCallDate());
        String dateCurent = TimerdataService().apiselectdateCallDate();
        newTripsController.getNewTrips(
            startdate: dateCurent == "null" ? "" : dateCurent,
            endDate: dateCurent == "null" ? "" : dateCurent);
      });
    });
    //  newTripsController.getNewTrips();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (newTripsController.dataLoading.value) {
        // Future.delayed(Duration(seconds: 2), () {
        //   newTripsController.isdataLoading(false);
        // });

        // Display the shimmer while loading
        return Center(child: NewOrdersBottomSheetShimmer());
      } else if (newTripsController.newTrips.isNotEmpty) {
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
                          'Total Orders: ${newTripsController.newTrips.length}',
                          style: CustomTextStyle.helloText,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newTripsController.newTrips.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            //       "accepted",
                            // "reachedPickup",
                            // "pickuped",
                            // "reachedDelivery"

                            if (newTripsController.newTrips[i]["tripStatus"] ==
                                    "accepted" ||
                                newTripsController.newTrips[i]
                                        ["tripStatus"] ==
                                    "reachedPickup" ||
                                newTripsController.newTrips[i]["tripStatus"] ==
                                    "pickuped" ||
                                newTripsController.newTrips[i]["tripStatus"] ==
                                    "reachedDelivery") {
                              Get.off(() => TripSummary(
                                    id: newTripsController.newTrips[i]["_id"]
                                        .toString(),
                                    orderId: newTripsController.newTrips[i]
                                            ["orderId"]
                                        .toString(),
                                  ));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurentBottomSheet(
                                    onReachedRestaurant: () {},
                                    reachedDelLocation: false,
                                    deltype: newTripsController.newTrips[i]
                                            ["deliveryType"]
                                        .toString(),
                                    id: newTripsController.newTrips[i]["_id"]
                                        .toString(),
                                    orderId: newTripsController.newTrips[i]
                                            ["orderId"]
                                        .toString(),
                                    onBackPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: NewTripCartDesign(
                            onAccept: widget.onAccept,
                            reachedDelLocation: false,
                            tripStatus: "orderAssigned",
                            dataList: newTripsController.newTrips,
                            index: i,
                          ),
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
    });
  }
}

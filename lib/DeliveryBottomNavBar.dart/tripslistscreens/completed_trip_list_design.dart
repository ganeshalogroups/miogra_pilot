import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/completed_trip_controller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/tripdetailsscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/earning_list_card_design.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/empty_order_design.dart';
import 'package:miogra_service/Shimmer/newordersshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompletedTripListScreen extends StatefulWidget {
  const CompletedTripListScreen({super.key});

  @override
  State<CompletedTripListScreen> createState() =>
      _CompletedTripListScreenState();
}

class _CompletedTripListScreenState extends State<CompletedTripListScreen> {
  final CompletedTripController completedTripController =
      Get.put(CompletedTripController());

  @override
  void initState() {
    print("timer +++++++++++++++++++++++++++++++++++++++");
    print(TimerdataService().apiselectdateCallDate());
    String dateCurent = TimerdataService().apiselectdateCallDate();
    super.initState();
    completedTripController.getCompletedData(
        startdate: dateCurent == "null" ? "" : dateCurent,
        endDate: dateCurent == "null" ? "" : dateCurent);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (completedTripController.dataLoading.value) {
        return Center(child: NewOrdersBottomSheetShimmer());
      } else if (completedTripController.newTrips.isNotEmpty) {
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
                          'Total Orders: ${completedTripController.newTrips.length}',
                          style: CustomTextStyle.helloText,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: completedTripController.newTrips.isEmpty
                          ? 0
                          : completedTripController.newTrips.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                                TripDetailsScreen(
                                    earnings:
                                        completedTripController.newTrips[i]),
                                transition: Transition.fadeIn);
                          },
                          child: EarningListCarddesign(
                            dataList: completedTripController.newTrips,
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

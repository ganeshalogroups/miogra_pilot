// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/Controller.dart/ProfileController/transactiondetailscontroller.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:miogra_service/widgets.dart/custom_trips.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatefulWidget {
  final Map<String, dynamic> transactionDetails;

  const TransactionDetails({super.key, required this.transactionDetails});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final TransactionDetailsController transactionDetailsController =
      Get.put(TransactionDetailsController());

  @override
  Widget build(BuildContext context) {
    var transactionDetails = widget.transactionDetails;
    var totalAmount =
        transactionDetails['amountDetails']?['totalAmount'].toString() ?? '';
    var orderDateTime = transactionDetails['createdAt'] ?? '';
    DateTime parsedDate = DateTime.parse(orderDateTime);
    var depositStatus = transactionDetails['depositStatus'] ?? '';
    String formattedDate =
        DateFormat('dd MMMM, yyyy | hh:mm a').format(parsedDate);
    // List orderDetails = transactionDetails['orderDetails'] ?? [];

    return Scaffold(
      backgroundColor: Customcolors.decorationbackground,
      appBar: AppBar(
        backgroundColor: Customcolors.decorationbackground,
        centerTitle: true,
        title: Text('Transaction Details', style: CustomTextStyle.screenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: CustomContainer(
                  // height: MediaQuery.of(context).size.height / 6.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Customcolors.decorationpureWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color
                        offset: const Offset(
                            0, 4), // Horizontal offset: 0, Vertical offset: 4
                        blurRadius: 1, // Blur radius
                        spreadRadius: 0, // Spread radius
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              // text: depositStatus == "deposited" ? totalAmount : '',
                              text: "Total Amount: ",
                              style: CustomTextStyle.normalblackText,
                            ),
                            // Spacer(),
                            CustomText(
                              // text: depositStatus == "deposited" ? totalAmount : '',
                              text: "₹ ${totalAmount}",
                              style: CustomTextStyle.normalblackText,
                            ),
                          ],
                        ),
                        CustomSizedBox(height: 8),
                        CustomText(
                          text:
                              'Total OFFLINE Amount: ₹ ${transactionDetails["amountDetails"]["offlineAmount"].toStringAsFixed(2)}',
                          style: CustomTextStyle.identityGreyText,
                        ),
                        CustomText(
                          // text: depositStatus == "deposited" ? formattedDate : '',
                          text: formattedDate,
                          style: CustomTextStyle.identityGreyText,
                        ),
                        CustomSizedBox(height: 8),
                        depositStatus == "deposited"
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                          'assets/images/stepsuccess.png'),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    CustomText(
                                      text: 'Success',
                                      style: CustomTextStyle.greenText,
                                    ),
                                  ],
                                ),
                              )
                            : depositStatus == "pending"
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                              'assets/images/pending.png'),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        CustomText(
                                          text: 'Pending',
                                          style: CustomTextStyle.blue13Text,
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                              'assets/images/failed.png'),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        CustomText(
                                          text: 'Failed',
                                          style: CustomTextStyle.redSmallText,
                                        ),
                                      ],
                                    ),
                                  )
                      ],
                    ),
                  ),
                ),
              ),
              CustomSizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: CustomContainer(
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Customcolors.decorationpureWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color
                        offset: const Offset(
                            0, 4), // Horizontal offset: 0, Vertical offset: 4
                        blurRadius: 1, // Blur radius
                        spreadRadius: 0, // Spread radius
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Order Details:",
                          style: CustomTextStyle.stepTitleText,
                        ),
                        CustomText(
                          text: "Total: $totalAmount",
                          style: CustomTextStyle.mobilelabelText,
                        ),
                        CustomText(
                          text:
                              "Tips: ${transactionDetails["amountDetails"]["tips"].toString() == "null" ? 0 : transactionDetails["amountDetails"]["tips"].toString()}",
                          style: CustomTextStyle.mobilelabelText,
                        ),
                        CustomText(
                          text:
                              "Deposit No: ${transactionDetails["depositNo"]}",
                          style: CustomTextStyle.mobilelabelText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: CustomContainer(
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Customcolors.decorationpureWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color
                        offset: const Offset(
                            0, 4), // Horizontal offset: 0, Vertical offset: 4
                        blurRadius: 1, // Blur radius
                        spreadRadius: 0, // Spread radius
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CustomText(
                          text: 'No.of trips include\nthe transaction',
                          style: CustomTextStyle.helloText,
                        ),
                        Spacer(),
                        CustomText(
                          text:
                              '${transactionDetails['orderDetails'].length}', // Replace with actual data if needed
                          style: CustomTextStyle.mediumblackText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // CustomSizedBox(height: 10),
              SizedBox(
                height: double.parse(
                        transactionDetails['orderDetails'].length.toString()) *
                    144,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactionDetails['orderDetails'].length,
                  itemBuilder: (context, index) {
                    //  var orderDetail = transactionDetails['orderDetails'][index];
                    var createdAt = transactionDetails['orderDetails'][index]
                        ['orderDetailsInfo']['createdAt'];
                    var createdAtdate = transactionDetails['orderDetails']
                        [index]['orderDetailsInfo']['createdAt'];
                    int totalKms = (transactionDetails['orderDetails'][index]
                                ['orderDetailsInfo']['totalKms'] as num?)
                            ?.toInt() ??
                        0;
                    var tips = transactionDetails['orderDetails'][index]
                        ["orderDetailsInfo"]["amountDetails"]["tips"];
                    // int totalKms = int.tryParse( transactionDetails['orderDetails'][index]['orderDetailsInfo']
                    //             ['totalKms']
                    //         .toString()) ??
                    //     0;
                    // int tripTimeInMinutes = totalKms * 5;

                    final tripAmount = transactionDetails['orderDetails'][index]
                                ["orderDetailsInfo"]["amountDetails"]
                            ?['deliveryCharges'] ??
                        0;

                    // DateTime customCreatedAt;
                    // try {
                    //   customCreatedAt = DateTime.parse(createdAt);
                    // } catch (e) {
                    //   customCreatedAt = DateTime.now();
                    // }

                    return CustomTrips(
                      isfromTransactionDetails: true,
                      itemCount: transactionDetails['orderDetails'].length,
                      deliverytext: ConstContentService().deliveryTypeMethod(
                          transactionDetails['orderDetails'][index]
                                  ['subAdminType']
                              .toString()),
                      orderId: transactionDetails['orderDetails'][index]
                              ['orderDetailsInfo']['orderCode'] ??
                          'Unknown',
                      dateText: createdAtdate,
                      timeText: createdAt,
                      // tripAmount:  transactionDetails['orderDetails'][index]['orderDetailsInfo']
                      //         ['amountDetails']['deliveryCharges'] ??
                      //     0,
                      tripAmount: tripAmount,
                      tripTime: tips,

                      ///here i passed tips instead of triptime because in backend api the object is not available
                      //  tripTimeInMinutes.toString(),
                      tripKm: totalKms,
                      rating: transactionDetails['orderDetails'][index]
                                  ['ratingAverage']
                              ?.toString() ??
                          0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

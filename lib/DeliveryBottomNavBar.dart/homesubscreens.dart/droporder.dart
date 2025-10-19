// ignore_for_file: depend_on_referenced_packages

import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderupdatecontroller.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/Shimmer/dropordershimmer.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class DropOrder extends StatefulWidget {
  final String id;
  const DropOrder({super.key, required this.id});

  @override
  State<DropOrder> createState() => _DropOrderState();
}

class _DropOrderState extends State<DropOrder> {
  final NewTripsController newTripsController = Get.put(NewTripsController());
  final OrderUpdateController orderUpdateController =
      Get.put(OrderUpdateController());

  bool _isChecked = false;
  bool _isCashChecked = false;
  List<bool> _isCheckedList = [];
  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newTripsController.getTripsbyId(widget.id);
    });
  }

  String parcelImage = "";
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false,
      // onPopInvoked: (bool didPop) async {
      //   return;
      // },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: CustomText(
              text: 'Drop Order',
              style: CustomTextStyle.screenTitle,
            ),
            //automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Obx(() {
                if (newTripsController.isdataLoading.value) {
                  return DropOrderShimmer();
                }

                if (newTripsController.newTripsbyid.isEmpty) {
                  return Center(child: Text('No data found'));
                }

                var tripData = newTripsController.newTripsbyid.first;

                var customerName = tripData['deliveryDetails']?[0]
                        ?['contactPerson'] ??
                    'UnKnown';
                var customerHousenumb =
                    tripData['deliveryDetails']?[0]?['houseNo'] ?? 'UnKnown';
                var customerLandMark =
                    tripData['deliveryDetails']?[0]?['landMark'] ?? 'UnKnown';
                var customerAddress = tripData['deliveryDetails']?[0]
                        ?['fullAddress'] ??
                    'UnKnown';
                var triptype = tripData['orderDetails']?['deliveryType'] ?? '';
                var additionalInstructions =
                    tripData['orderDetails']["additionalInstructions"];
                var paymentmethod =
                    tripData['orderDetails']["paymentMethod"] == "ONLINE"
                        ? "Online Payment"
                        : "Cash on Delivery";
                var orderDetails = tripData['orderDetails']?['ordersDetails'];
                if (orderDetails == null || orderDetails is! List) {
                  orderDetails = []; // Use an empty list if it's not a list.
                }

                if (_isCheckedList.isEmpty) {
                  _isCheckedList =
                      List<bool>.filled(orderDetails.length, false);
                }

                var finalAmount = tripData['orderDetails']?['amountDetails']
                            ?['finalAmount']
                        .toString() ??
                    '';

                var customerContact = tripData['deliveryDetails']?[0]
                        ?['contactPersonNumber'] ??
                    'UnKnown';
                var delType =
                    tripData['subAmdminDetails']?['subAdminType'] ?? 'Unknown';
                parcelImage = tripData['orderDetails']?['parcelDetails']
                        ?['packageImage'] ??
                    'Unknown';

                var parcelName = tripData['orderDetails']?['parcelDetails']
                        ?['packageType'] ??
                    'Unknown';
                var paymentMethod = tripData['orderDetails']?['paymentMethod'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:
                              'Order ID: #${tripData['orderDetails']?['orderCode'] ?? ''}',
                          style: CustomTextStyle.blueAmountText,
                        ),
                        CustomSizedBox(height: 10),
                        CustomContainer(
                          // height: MediaQuery.of(context).size.height / 7,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.white70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: delType == 'restaurant'
                                    ? 'Customer Info'
                                    : 'Drop Info',
                                style: CustomTextStyle.smallGreyText,
                              ),
                              CustomSizedBox(height: 10),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 7),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                'assets/images/homeicon.png',color: 
 Color(0xFF623089)
,),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: capitalizeFirstLetter(
                                                  customerName),
                                              style: CustomTextStyle.smallText,
                                            ),
                                            CustomText(
                                              text:
                                                  '${customerHousenumb ?? ''}, ${customerLandMark ?? ''}, ${customerAddress ?? ''}',
                                              style:
                                                  CustomTextStyle.smallGreyText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final Uri url = Uri.parse(
                                                  'tel:${customerContact ?? ''}');
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: SizedBox(
                                              //   color: Colors.deepOrange,
                                              height: 23,
                                              width: 23,
                                              child: Image.asset(
                                                  'assets/images/orangephone.png',color: Color(0xFF623089) ,),
                                            ),
                                          ),
                                          SizedBox(width: 25),
                                          GestureDetector(
                                            onTap: () async {
                                              final String phoneNumber =
                                                  "${customerContact ?? ''}"; // Replace with the actual phone number
                                              // ignore: prefer_const_declarations
                                              final String message =
                                                  "Your order has been in the doorstep";

                                              final Uri smsUri = Uri(
                                                scheme: 'sms',
                                                path: phoneNumber,
                                                query:
                                                    'body=${Uri.encodeComponent(message)}',
                                              );

                                              if (await canLaunchUrl(smsUri)) {
                                                await launchUrl(smsUri);
                                              } else {
                                                throw 'Could not send SMS to $phoneNumber';
                                              }
                                            },
                                            child: SizedBox(
                                              // color: Colors.deepOrange,
                                              height: 23,
                                              width: 23,
                                              child: Image.asset(
                                                  'assets/images/orangemessage.png',color:  Color(0xFF623089),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CustomSizedBox(height: 15),
                            ],
                          ),
                        ),
                        deliveryTypeDesignMethod(delType, orderDetails, context,
                            parcelImage, parcelName),
                        CustomSizedBox(height: 10),
                        if (paymentmethod != null && paymentmethod.isNotEmpty)
                          CustomContainer(
                            // height: MediaQuery.of(context).size.height / 12,
                            width: MediaQuery.of(context).size.width / 1,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.white70,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Payment Method:',
                                    style: CustomTextStyle.normalBoldText,
                                  ),
                                  CustomSizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset(
                                            'assets/images/income.png'),
                                      ),
                                      SizedBox(width: 17),
                                      CustomText(
                                        text: paymentmethod ?? '',
                                        style: CustomTextStyle.smallGreyText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (additionalInstructions != null &&
                            additionalInstructions.isNotEmpty)
                          CustomContainer(
                            height: MediaQuery.of(context).size.height / 12,
                            width: MediaQuery.of(context).size.width / 1,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.white70,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Delivery Instructions',
                                    style: CustomTextStyle.normalBoldText,
                                  ),
                                  CustomSizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        height: 17,
                                        width: 17,
                                        child: Image.asset(
                                          'assets/images/info.png',
                                          color: Customcolors.darkPurple,
                                        ),
                                      ),
                                      SizedBox(width: 17),
                                      CustomText(
                                        text: additionalInstructions ?? '',
                                        style: CustomTextStyle.smallGreyText,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        CustomSizedBox(height: 10),
                        CustomContainer(
                          height: MediaQuery.of(context).size.height / 14,
                          width: MediaQuery.of(context).size.width / 1,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: triptype == 'round'
                                      ? 'Parcel Picked '
                                      : 'Hand over the order',
                                  style: CustomTextStyle.normalBoldText,
                                ),
                                Checkbox(
                                  value: _isChecked,
                                  activeColor:  Color(0xFF623089),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomSizedBox(height: 10),
                        CustomContainer(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 1,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    paymentMethod == "OFFLINE"
                                        ? Text('Collect Cash ')
                                        : CustomText(
                                            text: 'Cash paid via UPI',
                                            style:
                                                CustomTextStyle.normalBoldText,
                                          ),
                                    CustomText(
                                      text: double.parse(finalAmount.toString())
                                          .toStringAsFixed(2),
                                      // '₹${finalAmount['finalAmount'] ?? ''}',
                                      style: CustomTextStyle.mediumText,
                                    ),
                                  ],
                                ),
                                paymentMethod == "OFFLINE"
                                    ? Checkbox(
                                        value: _isCashChecked,
                                        activeColor:
                                             Color(0xFF623089),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isCashChecked = value!;
                                          });
                                        },
                                      )
                                    : Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.asset(
                                                'assets/images/stepsuccess.png'),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          height: 10,
                        ),
                        CustomSizedBox(height: 20),
                      ],
                    ),
                    (paymentMethod != "OFFLINE"
                            ? _isChecked
                            : _isCashChecked && _isChecked)
                        ? CustomButton(
                          height: 50,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(20),
                            onPressed: orderUpdateController
                                    .isDeliveredUpdateLoading.value
                                ? null // Disable button if loading
                                : () async {
                                    if (triptype == 'round') {

                                      print("ORDER DELIVERED SUCCESS");
                                      // Navigate to the ReachDropLocationScreen
                                      await orderUpdateController
                                          .updatestartRoundTripUpdateDataStatus(
                                              tripData['_id'] ?? '',
                                              DateTime.now(),
                                              tripData['orderDetails']
                                                      ?['orderCode'] ??
                                                  '');
                                    } else {
                                         print("ORDER DELIVERED Failed");
                                      // Perform update status and other logic
                                      await orderUpdateController
                                          .updateDeliveredStatus(
                                              tripData['_id'] ?? '',
                                              DateTime.now());
                                    }
                                  },
                            child: orderUpdateController
                                    .isDeliveredUpdateLoading.value
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors
                                              .white), // Change color if needed
                                    ),
                                  )
                                : CustomText(
                                    text: triptype == 'round'
                                        ? 'Start Round Trip'
                                        : 'Order Delivered',
                                    style: CustomTextStyle.buttonText,
                                  ),
                          )
                        : CustomdisabledButton(
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () {},
                            child: CustomText(
                              text: triptype == 'round'
                                  ? 'Start Round Trip'
                                  : 'Order Delivered',
                              style: CustomTextStyle.greyButtonText,
                            ),
                          ),
                  ],
                );
              }),
            ),
          )),
    );
  }

  deliveryTypeDesignMethod(delType, List<dynamic> orderDetails,
      BuildContext context, parcelImage, parcelName) {
    if (delType == 'restaurant') {
      return foodAndMethodMEthodDesign(orderDetails, delType, context);
    } else if (delType == 'services') {
      return CustomContainer(
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Package Details', style: CustomTextStyle.normalBoldText),
              CustomSizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showImageOverlay(context);
                          },
                          child: Container(
                            height: 23,
                            width: 23,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "$globalImageUrlLink${parcelImage}"))),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parcelName ?? '',
                              style: CustomTextStyle.normalBoldText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (delType == 'meat') {
      return foodAndMethodMEthodDesign(orderDetails, delType, context);
    } else {
      return Text("new type $delType");
    }
  }

  CustomContainer foodAndMethodMEthodDesign(
      List<dynamic> orderDetails, delType, BuildContext context) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item Details', style: CustomTextStyle.normalBoldText),
            CustomSizedBox(height: 25),
            for (var i = 0; i < orderDetails.length; i++) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        delType == 'services'
                            ? GestureDetector(
                                onTap: () {
                                  showImageOverlay(context);
                                },
                                child: SizedBox(
                                  height: 23,
                                  width: 23,
                                  child:
                                      Image.asset('assets/images/package.png'),
                                ),
                              )
                            : (orderDetails[i]['foodType'] == 'veg'
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        'assets/images/veg-icon 1.png'),
                                  )
                                : (orderDetails[i]['foodType'] == 'egg'
                                    ? SizedBox(
                                        height: 23,
                                        width: 23,
                                        child: Image.asset(
                                            'assets/images/egg.jpg'),
                                      )
                                    : SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/non-veg-icon 1.png'),
                                      ))),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: Text(
                                '${orderDetails[i]['foodName'] ?? ''} x${orderDetails[i]['quantity'] ?? ''}',
                                style: CustomTextStyle.normalBoldText,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            CustomSizedBox(height: 5),
                            Text('₹${orderDetails[i]['foodPrice'] ?? ''} ',
                                style: CustomTextStyle.smallGreyText),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (i < orderDetails.length - 1) ...[
                CustomSizedBox(height: 10),
                DottedLine(
                  dashColor: Colors.grey,
                ),
                CustomSizedBox(height: 10),
              ]
            ],
          ],
        ),
      ),
    );
  }

  void showImageOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () =>
            overlayEntry.remove(), // Removing the overlay when tapped outside
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: PhotoView(
                imageProvider:
                    NetworkImage("$globalImageUrlLink${parcelImage}"),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

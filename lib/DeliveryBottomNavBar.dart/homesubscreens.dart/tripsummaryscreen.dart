import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderupdatecontroller.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/Shimmer/tripsummaryshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../../widgets.dart/custom_container.dart';

class TripSummary extends StatefulWidget {
  final String orderId;
  final String id;
  const TripSummary({
    super.key,
    required this.id,
    required this.orderId,
  });

  @override
  State<TripSummary> createState() => _TripSummaryState();
}

class _TripSummaryState extends State<TripSummary> {
  final NewTripsController newTripsController = Get.put(NewTripsController());
  OrderUpdateController orderUpdateController = OrderUpdateController();

  List<bool> _isCheckedList = [];
  bool parcelChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      newTripsController.getTripsbyId(widget.id);
    });
  }

  String parcelImage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomText(
            text: 'Trip Summary',
            style: CustomTextStyle.screenTitle,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(() {
            if (newTripsController.isdataLoading.value) {
              return TripSummaryShimmer();
            }

            if (newTripsController.newTripsbyid.isEmpty) {
              return Center(child: Text('No data found'));
            }

            var tripData = newTripsController.newTripsbyid.first;

            // Assuming the tripData contains the required fields based on the provided response.
            var restaurantName =
                tripData['subAmdminDetails']?['name'] ?? 'Unknown';
            var restaurantAddress = tripData['subAmdminDetails']?['address']
                    ?['fullAddress'] ??
                'Unknown';
            var customerName =
                tripData['deliveryDetails']?[0]?['contactPerson'] ?? 'Unknown';
            var customerHousenumb =
                tripData['deliveryDetails']?[0]?['houseNo'] ?? 'Unknown';
            var customerLandMark =
                tripData['deliveryDetails']?[0]?['landMark'] ?? 'Unknown';
            var customerAddress =
                tripData['deliveryDetails']?[0]?['fullAddress'] ?? 'Unknown';
            var orderDetails =
                tripData['orderDetails']?['ordersDetails'] ?? 'Unknown';
            var restImage =
                tripData['subAmdminDetails']?['imgUrl'] ?? 'Unknown';
            var delType = tripData['type'] ?? 'Unknown';
            parcelImage = tripData['orderDetails']?['parcelDetails']
                    ?['packageImage'] ??
                'Unknown';
            var parcelName = tripData['orderDetails']?['parcelDetails']
                    ?['packageType'] ??
                'Unknown';
            var additionalInstructions =
                tripData['orderDetails']["additionalInstructions"];
            var paymentmethod =
                tripData['orderDetails']["paymentMethod"] == "ONLINE"
                    ? "Online Payment"
                    : "Cash on Delivery";
            if (_isCheckedList.isEmpty) {
              _isCheckedList = List<bool>.filled(orderDetails.length, false);
            }

            bool areAllItemsChecked(type) {
              if (type == 'restaurant') {
                return _isCheckedList.every((checked) => checked);
              } else if (type == 'meat') {
                return _isCheckedList.every((checked) => checked);
              } else {
                return parcelChecked;
              }
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CustomContainer(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomSizedBox(height: 5),
                              Text(
                                  delType == 'restaurant'
                                      ? 'Restaurant Info'
                                      : 'Pickup Info',
                                  style: CustomTextStyle.smallGreyText),
                              CustomSizedBox(height: 15),
                              Row(
                                children: [
                                  Row(
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
                                              children: [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                CustomContainer(
                                                    height: 20,
                                                    width: 20,
                                                    child: Image.asset(
                                                        'assets/images/homeicon.png',color:  Color(0xFF623089),)),
                                              ],
                                            ),
                                      SizedBox(width: 15),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                delType == 'restaurant'
                                                    ? restaurantName
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
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              CustomSizedBox(height: 15),
                              DottedLine(dashColor: Colors.grey),
                              CustomSizedBox(height: 15),
                              CustomText(
                                  text: delType == 'restaurant'
                                      ? 'Customer Info'
                                      : 'Drop Info',
                                  style: CustomTextStyle.smallGreyText),
                              CustomSizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/homeicon.png',color: 
 Color(0xFF623089)
,),
                                      ),
                                      SizedBox(width: 15),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(customerName ?? '',
                                                style:
                                                    CustomTextStyle.smallText),
                                            Text(
                                              '${customerHousenumb ?? ''}, ${customerLandMark ?? ''}, ${customerAddress ?? ''}',
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
                            ],
                          ),
                        ),
                      ),
                      CustomContainer(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomSizedBox(
                                height: 15,
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
                                          height: 25,
                                          width: 25,
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
                              CustomSizedBox(height: 15),
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
                                          height: 17,
                                          width: 17,
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
                            ],
                          ),
                        ),
                      ),
                      checkedListItemMethod(delType, orderDetails, context,
                          parcelImage, parcelName)
                    ],
                  ),
                  SizedBox(height: 30),
                  areAllItemsChecked(delType)
                      ? CustomButton(
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(20),
                          onPressed: () {
                               print("Botton aa Pressing    ${  tripData['_id']}");
                            orderUpdateController.updatePickedRestaurentStatus(
                                tripData['_id'] ?? '',
                                DateTime.now(),
                                tripData['orderId']);
                     
                          },
                          child: CustomText(
                            text: ConstContentService()
                                .deliveryBottonTypeMethod(delType),
                            // text: delType == 'restaurant'
                            //     ? 'Picked Order'
                            //     : 'Picked Parcel',
                            style: CustomTextStyle.buttonText,
                          ))
                      : CustomdisabledButton(
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(20),
                          onPressed: () {
                            print("Bitton Pressing");
                          },
                          child: CustomText(
                            text: ConstContentService()
                                .deliveryBottonTypeMethod(delType),
                            style: CustomTextStyle.greyButtonText,
                          )),
                ],
              ),
            );
          }),
        ));
  }

  checkedListItemMethod(
      delType, orderDetails, BuildContext context, parcelImage, parcelName) {
    if (delType == 'restaurant') {
      return CustomContainer(
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checked Item', style: CustomTextStyle.normalBoldText),
              CustomSizedBox(height: 25),
              for (var i = 0; i < orderDetails.length; i++) ...[
                if (orderDetails[i] is Map)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (orderDetails[i]['foodType'] == 'veg')
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        'assets/images/veg-icon 1.png'),
                                  )
                                : (orderDetails[i]['foodType'] == 'egg')
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
                                      ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
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
                        Checkbox(
                          value: _isCheckedList[i],
                          activeColor: 
 Color(0xFF623089),

                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedList[i] = value ?? false;
                            });
                          },
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
    } else if (delType == 'services') {
      return CustomContainer(
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checked Item', style: CustomTextStyle.normalBoldText),
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
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 10,
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
                    Checkbox(
                      value: parcelChecked,
                      activeColor: Color.fromARGB(255, 249, 120, 0),
                      onChanged: (bool? value) {
                        setState(() {
                          parcelChecked = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (delType == 'meat') {
      return CustomContainer(
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checked Item', style: CustomTextStyle.normalBoldText),
              CustomSizedBox(height: 25),
              for (var i = 0; i < orderDetails.length; i++) ...[
                if (orderDetails[i] is Map)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                height: 20,
                                width: 20,
                                child: Image.asset('assets/images/nonveg.png')),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
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
                        Checkbox(
                          value: _isCheckedList[i],
                          activeColor: Color.fromARGB(255, 249, 120, 0),
                          onChanged: (bool? value) {
                            setState(() {
                              _isCheckedList[i] = value ?? false;
                            });
                          },
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
    } else {
      return Text("new type $delType");
    }
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

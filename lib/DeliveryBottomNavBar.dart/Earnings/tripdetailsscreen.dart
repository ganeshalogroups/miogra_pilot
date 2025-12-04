// import 'package:dotted_line/dotted_line.dart';
// import 'package:miogra_service/Const.dart/const_colors.dart';
// import 'package:miogra_service/Const.dart/const_content_service.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/widgets.dart/custom_container.dart';
// import 'package:miogra_service/widgets.dart/custom_space.dart';
// import 'package:miogra_service/widgets.dart/custom_text.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:miogra_service/widgets.dart/custom_trips.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:photo_view/photo_view.dart';

// class TripDetailsScreen extends StatefulWidget {
//   final dynamic earnings;
//   const TripDetailsScreen({super.key, this.earnings});

//   @override
//   State<TripDetailsScreen> createState() => _TripDetailsScreenState();
// }

// class _TripDetailsScreenState extends State<TripDetailsScreen> {
//   final List<String> ordersummary = [
//     'Order ID',
//     'Order Type',
//     'Order Status',
//     'Order Date',
//     'Delivered Time',
//     'Payment Method',
//   ];

//   final List<String> tripsummary = [
//     'Trip Cost',
//     'Trip Time',
//     'Total Km',
//     'Rating',
//   ];

//   List<bool> _isCheckedList = [];

//   @override
//   Widget build(BuildContext context) {
//     final List<String> cost = [
//       'Item Total',
//       'GST',
//       'Delivery partner fee(up to ${widget.earnings['orderDetails']?['totalKms'] ?? '0.0'} km)',
//       "Packing Charge",
//       "Platform Fee",
//       "Delivery Tip",
//       "Coupon Discount",
//     ];
//     var earningsDetails = widget.earnings!;
//     var orderId = earningsDetails['orderDetails']?['orderCode'] ?? 'N/A';
//     var orderType = earningsDetails['orderDetails']?['subAdminType'] ?? 'N/A';
//     var tripCost = earningsDetails['orderDetails']?['amountDetails']
//                 ?['deliveryCharges']
//             .toString() ??
//         '₹0.00';
//     var tripKm =
//         earningsDetails['orderDetails']?['totalKms']?.toString() ?? '0.0';
//     print(
//         'tripkm/........${earningsDetails['orderDetails']?['totalKms']?.toString()}');
//     var paymentMethod =
//         earningsDetails['orderDetails']?['paymentMethod'] ?? 'Unknown';

//     var restName = earningsDetails['tripDetails']['pickupDetails'][0]['name']
//             .toString()
//             .capitalizeFirst ??
//         'Unknown Restaurant';
//     var restAddress = earningsDetails['tripDetails']['pickupDetails'][0]
//             ['fullAddress'] ??
//         'Unknown Address';

//     var deliveryDetails = earningsDetails['tripDetails']['deliveryDetails'] ??
//         {'name': 'Customer', 'fullAddress': 'Customer Address'};
//     var custName = deliveryDetails[0]['name'].toString().capitalizeFirst;
//     var customerName =
//         deliveryDetails[0]['contactPerson'].toString().capitalizeFirst ??
//             'Customer';
//     var custAddress = deliveryDetails[0]['fullAddress'] ?? 'Customer Address';

//     var itemTotal = earningsDetails['orderDetails']?['amountDetails']
//                 ?['cartFoodAmountWithoutCoupon']
//             .toString() ??
//         '₹0.00';

//     var gst =
//         earningsDetails['orderDetails']?['amountDetails']?['tax'].toString() ??
//             '₹0.00';
//     var deliverytip =
//         earningsDetails['orderDetails']?['amountDetails']?['tips'].toString() ??
//             '₹0.00';
//     var deliveryCharges = earningsDetails['orderDetails']?['amountDetails']
//                 ?['deliveryCharges']
//             .toString() ??
//         '₹0.00';
//     var coupenDiscount = earningsDetails['orderDetails']?['amountDetails']
//                 ?['couponsAmount']
//             .toString() ??
//         '₹0.00';
//     var grandTotal = earningsDetails['orderDetails']?['amountDetails']
//                 ?['finalAmount']
//             .toString() ??
//         '₹0.00';
//     var packingcharge = earningsDetails['orderDetails']?['amountDetails']
//                 ?['packingCharges']
//             .toString() ??
//         '₹0.00';
//     var platformfee = earningsDetails['orderDetails']?['amountDetails']
//                 ?['platformFee']
//             .toString() ??
//         '₹0.00';
//     var additionalInstructions =
//         earningsDetails['orderDetails']["additionalInstructions"];
//     var paymentmethod =
//         earningsDetails['orderDetails']["paymentMethod"] == "ONLINE"
//             ? "Online Payment"
//             : "Cash on Delivery";
//     var createdAtString = earningsDetails['tripDetails']['deliveredAt'] ?? '';

//     DateTime createdAt;
//     try {
//       // Check if the date is in a valid format before parsing
//       if (createdAtString.isNotEmpty && createdAtString.length >= 10) {
//         createdAt = DateTime.parse(createdAtString);
//       } else {
//         createdAt = DateTime.now(); // Fallback to current date if invalid
//       }
//     } catch (e) {
//       createdAt = DateTime.now(); // Fallback to current date if parsing fails
//     }

//     var tripKms = double.tryParse(tripKm) ?? 0;
//     print('kmmmm/.............$tripKms');
//     int tripTimeInMinutes = (tripKms * 5).toInt();
//     final ratingList =
//         (earningsDetails['orderDetails']?['rating']?.isNotEmpty ?? false)
//             ? (earningsDetails['orderDetails']['rating'][0]['rating'] is String
//                 ? double.tryParse(earningsDetails['orderDetails']['rating'][0]
//                         ['rating']) ??
//                     0.0
//                 : earningsDetails['orderDetails']['rating'][0]['rating']
//                         ?.toDouble() ??
//                     0.0)
//             : 0.0;
//     var orderDetails = earningsDetails['orderDetails']?['ordersDetails'];
//     if (orderDetails == null || orderDetails is! List) {
//       orderDetails = []; // Use an empty list if it's not a list.
//     }

//     if (_isCheckedList.isEmpty) {
//       _isCheckedList = List<bool>.filled(orderDetails.length, false);
//     }

//     final List<String> ordersummaryDetails = [
//       orderId,
//       ConstContentService().deliveryTypeMethod(orderType),
//       'Completed',
//       DateFormat('dd/MM/yyyy').format(createdAt),
//       // DateFormat('hh:mm a').format(createdAt),
//       formatDate(dateStr: createdAtString),
//       paymentMethod == "OFFLINE" ? 'Cash On Delivery' : 'Online Payment',
//     ];

//     final List<String> tripsummaryDetails = [
//       '₹ ${double.parse(tripCost).toStringAsFixed(2)}',
//       earningsDetails['tripDetails']["tripTime"] == null
//           ? "0 mins"
//           : '${earningsDetails['tripDetails']["tripTime"].toString()} mins',
//       "${tripKm} km",
//       ratingList.toString(),
//     ];

//     final List<String> costDetails = [
//       '₹ ${double.tryParse(itemTotal)?.toStringAsFixed(2) ?? "0.00"}',
//       '₹ ${double.tryParse(gst)?.toStringAsFixed(2) ?? "0.00"}',
//       '₹ ${double.tryParse(deliveryCharges)?.toStringAsFixed(2) ?? "0.00"}',
//       '₹ ${double.tryParse(packingcharge)?.toStringAsFixed(2) ?? "0.00"}',
//       '₹ ${double.tryParse(platformfee)?.toStringAsFixed(2) ?? "0.00"}',
//       '₹ ${double.tryParse(deliverytip)?.toStringAsFixed(2) ?? "0.00"}',
//       coupenDiscount == '0' ? '₹$coupenDiscount' : '-₹$coupenDiscount',
//     ];
//     var parcelImage = earningsDetails['orderDetails']?['parcelDetails']
//             ?['packageImage'] ??
//         'Unknown';

//     var parcelName =
//         earningsDetails['orderDetails']?['subAdminType'] ?? 'Unknown';

//     void showImageOverlay(BuildContext context) {
//       OverlayState? overlayState = Overlay.of(context);
//       late OverlayEntry overlayEntry;

//       overlayEntry = OverlayEntry(
//         builder: (context) => GestureDetector(
//           onTap: () => overlayEntry.remove(),
//           child: Material(
//             color: Colors.transparent,
//             child: Center(
//               child: SizedBox(
//                 height: 300,
//                 width: 300,
//                 child: PhotoView(
//                   imageProvider:
//                       NetworkImage("$globalImageUrlLink${parcelImage}"),
//                   minScale: PhotoViewComputedScale.contained,
//                   maxScale: PhotoViewComputedScale.covered * 2,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );

//       overlayState.insert(overlayEntry);
//     }

//     return Scaffold(
//       backgroundColor: Customcolors.decorationbackground,
//       appBar: AppBar(
//         backgroundColor: Customcolors.decorationbackground,
//         centerTitle: true,
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
//             onPressed: () => Navigator.pop(context)),
//         title: CustomText(
//           text: 'Trip Details',
//           style: CustomTextStyle.screenTitle,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomContainer(
//                 borderRadius: BorderRadius.circular(15),
//                 backgroundColor: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 5.0),
//                         child: CustomText(
//                           text: 'Order Summary',
//                           style: CustomTextStyle.detailsDetText,
//                         ),
//                       ),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: ordersummary.length,
//                         itemBuilder: (context, index) {
//                           bool isSecondIndex = index == 2;

//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 CustomText(
//                                   text: ordersummary[index],
//                                   style: CustomTextStyle.seemore10,
//                                 ),
//                                 CustomText(
//                                   text: ordersummaryDetails[index],
//                                   style: isSecondIndex
//                                       ? CustomTextStyle.seemore10
//                                           .copyWith(color: Colors.green)
//                                       : CustomTextStyle.seemore10,
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               CustomContainer(
//                 borderRadius: BorderRadius.circular(15),
//                 backgroundColor: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 5.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             CustomText(
//                               text: 'Receiver Details',
//                               style: CustomTextStyle.detailsDetText,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'Receiver Name:  ', // Label
//                                 style: CustomTextStyle
//                                     .darksmallblack, // Your label style
//                               ),
//                               TextSpan(
//                                 text:
//                                     deliveryDetails[0]['contactPerson'].isEmpty
//                                         ? deliveryDetails[0]['name']
//                                             .toString()
//                                             .capitalizeFirst
//                                         : deliveryDetails[0]['contactPerson']
//                                             .toString()
//                                             .capitalizeFirst,
//                                 style: CustomTextStyle
//                                     .detailsTitleText, // <-- your data style
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'Receiver Address:  ',
//                                 style: CustomTextStyle.darksmallblack,
//                               ),
//                               TextSpan(
//                                 text: custAddress ?? '',
//                                 style: CustomTextStyle.detailsTitleText,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'Receiver Contact:  ',
//                                 style: CustomTextStyle.darksmallblack,
//                               ),
//                               TextSpan(
//                                 text: earningsDetails['tripDetails']
//                                             ['deliveryDetails'][0]
//                                         ["contactPersonNumber"] ??
//                                     '',
//                                 style: CustomTextStyle.detailsTitleText,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         additionalInstructions != null &&
//                                 additionalInstructions.isNotEmpty
//                             ? RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: 'Delivery Instructions:  ',
//                                       style: CustomTextStyle.darksmallblack,
//                                     ),
//                                     TextSpan(
//                                       text:
//                                           "${additionalInstructions.toString()}" ??
//                                               '',
//                                       style: CustomTextStyle.detailsTitleText,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : SizedBox(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               CustomContainer(
//                 // height: tripsummary.length *
//                 //     MediaQuery.of(context).size.height /
//                 //     22,
//                 borderRadius: BorderRadius.circular(15),
//                 backgroundColor: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 5.0),
//                         child: CustomText(
//                           text: 'Trip Summary',
//                           style: CustomTextStyle.detailsDetText,
//                         ),
//                       ),
//                       SizedBox(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: tripsummary.length,
//                           itemBuilder: (context, index) {
//                             bool isThirdIndex = index == 3;
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   CustomText(
//                                     text: tripsummary[index],
//                                     style: CustomTextStyle.seemore10,
//                                   ),
//                                   Row(
//                                     children: [
//                                       isThirdIndex
//                                           ? SizedBox(
//                                               height: 25,
//                                               width: 25,
//                                               child: Image.asset(
//                                                   'assets/images/rating.png'))
//                                           : SizedBox(),
//                                       CustomText(
//                                         text: tripsummaryDetails[index],
//                                         style: CustomTextStyle.seemore10,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               CustomContainer(
//                 borderRadius: BorderRadius.circular(15),
//                 backgroundColor: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: 'Details',
//                         style: CustomTextStyle.detailsDetText,
//                       ),
//                       SizedBox(height: 20),
//                       CustomText(
//                         text: restName,
//                         style: CustomTextStyle.addressGreyText,
//                       ),
//                       SizedBox(height: 10),
//                       CustomText(
//                         text: restAddress ?? '',
//                         style: CustomTextStyle.addressGreyText,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               CustomContainer(
//                 width: MediaQuery.of(context).size.width / 1,
//                 borderRadius: BorderRadius.circular(15),
//                 backgroundColor: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: 'Deliver to',
//                         style: CustomTextStyle.detailsTitleText,
//                       ),
//                       SizedBox(height: 20),
//                       CustomText(
//                         text: custName ?? customerName,
//                         style: CustomTextStyle.detailsDetText,
//                       ),
//                       SizedBox(height: 10),
//                       CustomText(
//                         text: custAddress ?? '',
//                         style: CustomTextStyle.addressGreyText,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               orderType == 'services'
//                   ? parcelDesignMethod(
//                       showImageOverlay, context, parcelImage, parcelName)
//                   : foodDesignMethod(
//                       orderDetails, orderType, showImageOverlay, context),
//               SizedBox(height: 20),
//               DottedLine(dashColor: Colors.grey.shade500),
//               SizedBox(height: 20),
//               CustomContainer(
//                 backgroundColor: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: cost.length,
//                         itemBuilder: (context, index) {
//                           bool isfourthIndex = index == 6;
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 CustomText(
//                                   text: cost[index],
//                                   style: CustomTextStyle.seemore10,
//                                 ),
//                                 CustomText(
//                                   text: costDetails[index],
//                                   style: isfourthIndex
//                                       ? CustomTextStyle.seemore10
//                                           .copyWith(color: Colors.green)
//                                       : CustomTextStyle.seemore10,
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     DottedLine(dashColor: Colors.grey.shade500),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomText(
//                             text: 'Grand Total',
//                             style: CustomTextStyle.seemore10,
//                           ),
//                           CustomText(
//                             text: '₹$grandTotal',
//                             style: CustomTextStyle.itemBoldText,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 35),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   CustomContainer foodDesignMethod(List<dynamic> orderDetails, orderType,
//       void showImageOverlay(BuildContext context), BuildContext context) {
//     return CustomContainer(
//       borderRadius: BorderRadius.circular(15),
//       backgroundColor: Colors.white70,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Bill Summary', style: CustomTextStyle.detailsTitleText),
//             CustomSizedBox(height: 25),
//             for (var i = 0; i < orderDetails.length; i++) ...[
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             orderType == 'services'
//                                 ? GestureDetector(
//                                     onTap: () {
//                                       showImageOverlay(context);
//                                     },
//                                     child: SizedBox(
//                                       height: 23,
//                                       width: 23,
//                                       child: Image.asset(
//                                           'assets/images/package.png'),
//                                     ),
//                                   )
//                                 : (orderDetails[i]['foodType'] == 'veg'
//                                     ? SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: Image.asset(
//                                             'assets/images/veg-icon 1.png'),
//                                       )
//                                     : (orderDetails[i]['foodType'] == 'egg'
//                                         ? SizedBox(
//                                             height: 23,
//                                             width: 23,
//                                             child: Image.asset(
//                                                 'assets/images/egg.jpg'),
//                                           )
//                                         : SizedBox(
//                                             height: 20,
//                                             width: 20,
//                                             child: Image.asset(
//                                                 'assets/images/non-veg-icon 1.png'),
//                                           ))),
//                             SizedBox(width: 15),
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width / 1.8,
//                                   child: Text(
//                                     '${orderDetails[i]['quantity'] ?? ''}  x ${orderDetails[i]['foodName'] ?? ''}',
//                                     style: CustomTextStyle.itemBoldText,
//                                     overflow: TextOverflow.clip,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         CustomSizedBox(width: 5),
//                         Text('₹${orderDetails[i]['foodPrice'] ?? ''} ',
//                             style: CustomTextStyle.seemore10),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   CustomContainer parcelDesignMethod(
//       void showImageOverlay(BuildContext context),
//       BuildContext context,
//       parcelImage,
//       parcelName) {
//     return CustomContainer(
//       borderRadius: BorderRadius.circular(15),
//       backgroundColor: Colors.white70,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Package Details', style: CustomTextStyle.normalBoldText),
//             CustomSizedBox(height: 25),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           showImageOverlay(context);
//                         },
//                         child: Container(
//                           height: 23,
//                           width: 23,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       "$globalImageUrlLink${parcelImage}"))),
//                         ),
//                       ),
//                       SizedBox(width: 15),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             parcelName ?? '',
//                             style: CustomTextStyle.normalBoldText,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



















import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:miogra_service/widgets.dart/custom_trips.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class TripDetailsScreen extends StatefulWidget {
  final dynamic earnings;
  const TripDetailsScreen({super.key, this.earnings});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final List<String> ordersummary = [
    'Order ID',
    'Order Type',
    'Order Status',
    'Order Date',
    'Delivered Time',
    'Payment Method',
  ];

  final List<String> tripsummary = [
    'Trip Cost',
    'Trip Time',
    'Total Km',
    'Rating',
  ];

  List<bool> _isCheckedList = [];

  @override
  Widget build(BuildContext context) {

   // print("AAAAAA  ${widget.earnings}");


    // final List<String> cost = [
    //   'Item Total',
    //   'GST',
    //   'Delivery partner fee(up to ${widget.earnings['orderDetails']?['totalKms'] ?? '0.0'} km)',
    //   "Packing Charge",
    //   "Platform Fee",
    //   "Delivery Tip",
    //   "Coupon Discount",
    // ];


    var earningsDetails = widget.earnings!;
    var orderId = earningsDetails['orderDetails']?['orderCode'] ?? 'N/A';
    var orderType = earningsDetails['orderDetails']?['subAdminType'] ?? 'N/A';
    var tripCost = earningsDetails['orderDetails']?['amountDetails']
                ?['deliveryCharges']
            .toString() ??
        '₹0.00';
    var tripKm =
        earningsDetails['orderDetails']?['totalKms']?.toString() ?? '0.0';
    print(
        'tripkm/........${earningsDetails['orderDetails']?['totalKms']?.toString()}');
    var paymentMethod =
        earningsDetails['orderDetails']?['paymentMethod'] ?? 'Unknown';

    var restName = earningsDetails['restaurantDetails']["name"]
            .toString()
            .capitalizeFirst ??
        'Unknown Restaurant';
    var restAddress = earningsDetails['restaurantDetails']["address"]
            ['fullAddress'] ??
        'Unknown Address';

    var deliveryDetails = earningsDetails["orderDetails"]["dropAddress"] ??
        {'name': 'Customer', 'fullAddress': 'Customer Address'};
    var custName = deliveryDetails[0]['name'].toString().capitalizeFirst;
    var customerName =
        deliveryDetails[0]['contactPerson'].toString().capitalizeFirst ??
            'Customer';
    var custAddress = deliveryDetails[0]['fullAddress'] ?? 'Customer Address';

    var itemTotal = earningsDetails['orderDetails']?['amountDetails']
                ?['cartFoodAmountWithoutCoupon']
            .toString() ??
        '₹0.00';

    var gst = ((earningsDetails['orderDetails']?['amountDetails']?['tax'] ?? 0) +
                (earningsDetails['orderDetails']?['amountDetails']?['otherCharges'] ?? 0))
                .toString();
    var deliverytip =
        earningsDetails['orderDetails']?['amountDetails']?['tips'].toString() ??
            '₹0.00';
    var deliveryCharges = earningsDetails['orderDetails']?['amountDetails']
                ?['deliveryCharges']
            .toString() ??
        '₹0.00';
    var coupenDiscount = earningsDetails['orderDetails']?['amountDetails']
                ?['couponsAmount']
            .toString() ??
        '₹0.00';
    var commissionres = earningsDetails['orderDetails']?['amountDetails']
                ?['commissionAmount']
            .toString() ??
        '₹0.00';
    var grandTotal = earningsDetails['orderDetails']?['amountDetails']
                ?['finalAmount']
            .toString() ??
        '₹0.00';
    var packingcharge = earningsDetails['orderDetails']?['amountDetails']
                ?['packingCharges']
            .toString() ??
        '₹0.00';
    var platformfee = earningsDetails['orderDetails']?['amountDetails']
                ?['platformFee']
            .toString() ??
        '₹0.00';
    var additionalInstructions =
        earningsDetails['orderDetails']["additionalInstructions"];
    var paymentmethod =
        earningsDetails['orderDetails']["paymentMethod"] == "ONLINE"
            ? "Online Payment"
            : "Cash on Delivery";
    var createdAtString = earningsDetails["date"] ?? '';

    DateTime createdAt;
    try {
      // Check if the date is in a valid format before parsing
      if (createdAtString.isNotEmpty && createdAtString.length >= 10) {
        createdAt = DateTime.parse(createdAtString);
      } else {
        createdAt = DateTime.now(); // Fallback to current date if invalid
      }
    } catch (e) {
      createdAt = DateTime.now(); // Fallback to current date if parsing fails
    }

    var tripKms = double.tryParse(tripKm) ?? 0;
    print('kmmmm/.............$tripKms');
    int tripTimeInMinutes = (tripKms * 5).toInt();
    final ratingList =
        (earningsDetails['orderDetails']?['rating']?.isNotEmpty ?? false)
            ? (earningsDetails['orderDetails']['rating'][0]['rating'] is String
                ? double.tryParse(earningsDetails['orderDetails']['rating'][0]
                        ['rating']) ??
                    0.0
                : earningsDetails['orderDetails']['rating'][0]['rating']
                        ?.toDouble() ??
                    0.0)
            : 0.0;
    var orderDetails = earningsDetails['orderDetails']?['ordersDetails'];
    if (orderDetails == null || orderDetails is! List) {
      orderDetails = []; // Use an empty list if it's not a list.
    }

    if (_isCheckedList.isEmpty) {
      _isCheckedList = List<bool>.filled(orderDetails.length, false);
    }

    final List<String> ordersummaryDetails = [
      orderId,
      ConstContentService().deliveryTypeMethod(orderType),
      'Completed',
      DateFormat('dd/MM/yyyy').format(createdAt),
      // DateFormat('hh:mm a').format(createdAt),
      formatDate(dateStr: createdAtString),
      paymentMethod == "OFFLINE" ? 'Cash On Delivery' : 'Online Payment',
    ];
print("  BBBBBBB  $ordersummaryDetails");


    final List<String> tripsummaryDetails = [
      '₹ ${double.parse(tripCost).toStringAsFixed(2)}',
      earningsDetails[ "tripTime"] == null
          ? "0 mins"
          : '${earningsDetails[ "tripTime"].toString()} mins',
      "${tripKm} km",
      ratingList.toString(),
    ];

    // final List<String> costDetails = [
    //   '₹ ${double.tryParse(itemTotal)?.toStringAsFixed(2) ?? "0.00"}',
    //   '₹ ${double.tryParse(gst)?.toStringAsFixed(2) ?? "0.00"}',
    //   '₹ ${double.tryParse(deliveryCharges)?.toStringAsFixed(2) ?? "0.00"}',
    //   '₹ ${double.tryParse(packingcharge)?.toStringAsFixed(2) ?? "0.00"}',
    //   '₹ ${double.tryParse(platformfee)?.toStringAsFixed(2) ?? "0.00"}',
    //   '₹ ${double.tryParse(deliverytip)?.toStringAsFixed(2) ?? "0.00"}',
    //   coupenDiscount == '0' ? '₹$coupenDiscount' : '-₹$coupenDiscount',
    // ];




final List<String> cost = [];
final List<String> costDetails = [];

// Always show
cost.add("Item Total");
costDetails.add("₹ ${double.tryParse(itemTotal)?.toStringAsFixed(2) ?? "0.00"}");

cost.add("GST and Other Charges");
costDetails.add("₹ ${double.tryParse(gst)?.toStringAsFixed(2) ?? "0.00"}");

cost.add("Delivery partner fee(up to ${widget.earnings['orderDetails']?['totalKms'] ?? '0.0'} km)");
costDetails.add("₹ ${double.tryParse(deliveryCharges)?.toStringAsFixed(2) ?? "0.00"}");

cost.add("Packing Charge");
costDetails.add("₹ ${double.tryParse(packingcharge)?.toStringAsFixed(2) ?? "0.00"}");

cost.add("Platform Fee");
costDetails.add("₹ ${double.tryParse(platformfee)?.toStringAsFixed(2) ?? "0.00"}");

// Show Delivery Tip only if > 0
final tip = double.tryParse(deliverytip) ?? 0;
if (tip > 0) {
  cost.add("Delivery Tip");
  costDetails.add("₹ ${tip.toStringAsFixed(2)}");
}

// Show Coupon Discount only if > 0
final discount = double.tryParse(coupenDiscount) ?? 0;
if (discount > 0) {
  cost.add("Coupon Discount");
  costDetails.add("-₹ ${discount.toStringAsFixed(2)}");
}

final commission = double.tryParse(commissionres) ?? 0;
if (commission > 0) {
  cost.add("Commission");
  costDetails.add("₹ ${commission.toStringAsFixed(2)}");
}










    
    var parcelImage = earningsDetails['orderDetails']?['parcelDetails']
            ?['packageImage'] ??
        'Unknown';

    var parcelName =
        earningsDetails['orderDetails']?['subAdminType'] ?? 'Unknown';

    void showImageOverlay(BuildContext context) {
      OverlayState? overlayState = Overlay.of(context);
      late OverlayEntry overlayEntry;

      overlayEntry = OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: () => overlayEntry.remove(),
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

    return Scaffold(
      backgroundColor: Customcolors.decorationbackground,
      appBar: AppBar(
        backgroundColor: Customcolors.decorationbackground,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
            onPressed: () => Navigator.pop(context)),
        title: CustomText(
          text: 'Trip Details',
          style: CustomTextStyle.screenTitle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: CustomText(
                          text: 'Order Summary',
                          style: CustomTextStyle.detailsDetText,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ordersummary.length,
                        itemBuilder: (context, index) {
                          bool isSecondIndex = index == 2;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: ordersummary[index],
                                  style: CustomTextStyle.seemore10,
                                ),
                                CustomText(
                                  text: ordersummaryDetails[index],
                                  style: isSecondIndex
                                      ? CustomTextStyle.seemore10
                                          .copyWith(color: Colors.green)
                                      : CustomTextStyle.seemore10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomContainer(
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: 'Receiver Details',
                              style: CustomTextStyle.detailsDetText,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Receiver Name:  ', // Label
                                style: CustomTextStyle
                                    .darksmallblack, // Your label style
                              ),
                              TextSpan(
                                text:
                                    deliveryDetails[0]['contactPerson'].isEmpty
                                        ? deliveryDetails[0]['name']
                                            .toString()
                                            .capitalizeFirst
                                        : deliveryDetails[0]['contactPerson']
                                            .toString()
                                            .capitalizeFirst,
                                style: CustomTextStyle
                                    .detailsTitleText, // <-- your data style
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Receiver Address:  ',
                                style: CustomTextStyle.darksmallblack,
                              ),
                              TextSpan(
                                text: custAddress ?? '',
                                style: CustomTextStyle.detailsTitleText,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Receiver Contact:  ',
                                style: CustomTextStyle.darksmallblack,
                              ),
                              TextSpan(
                                text: earningsDetails[ "orderDetails"]
                                            [ "dropAddress"][0]
                                        ["contactPersonNumber"] ??
                                    '',
                                style: CustomTextStyle.detailsTitleText,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        additionalInstructions != null &&
                                additionalInstructions.isNotEmpty
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Delivery Instructions:  ',
                                      style: CustomTextStyle.darksmallblack,
                                    ),
                                    TextSpan(
                                      text:
                                          "${additionalInstructions.toString()}" ??
                                              '',
                                      style: CustomTextStyle.detailsTitleText,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomContainer(
                // height: tripsummary.length *
                //     MediaQuery.of(context).size.height /
                //     22,
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: CustomText(
                          text: 'Trip Summary',
                          style: CustomTextStyle.detailsDetText,
                        ),
                      ),
                      SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tripsummary.length,
                          itemBuilder: (context, index) {
                            bool isThirdIndex = index == 3;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: tripsummary[index],
                                    style: CustomTextStyle.seemore10,
                                  ),
                                  Row(
                                    children: [
                                      isThirdIndex
                                          ? SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image.asset(
                                                  'assets/images/rating.png'))
                                          : SizedBox(),
                                      CustomText(
                                        text: tripsummaryDetails[index],
                                        style: CustomTextStyle.seemore10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomContainer(
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Details',
                        style: CustomTextStyle.detailsDetText,
                      ),
                      SizedBox(height: 20),
                      CustomText(
                        text: restName,
                        style: CustomTextStyle.addressGreyText,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: restAddress ?? '',
                        style: CustomTextStyle.addressGreyText,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomContainer(
                width: MediaQuery.of(context).size.width / 1,
                borderRadius: BorderRadius.circular(15),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Deliver to',
                        style: CustomTextStyle.detailsTitleText,
                      ),
                      SizedBox(height: 20),
                      CustomText(
                        text: custName ?? customerName,
                        style: CustomTextStyle.detailsDetText,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: custAddress ?? '',
                        style: CustomTextStyle.addressGreyText,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              orderType == 'services'
                  ? parcelDesignMethod(
                      showImageOverlay, context, parcelImage, parcelName)
                  : foodDesignMethod(
                      orderDetails, orderType, showImageOverlay, context),
              SizedBox(height: 20),
              DottedLine(dashColor: Colors.grey.shade500),
              SizedBox(height: 20),
              CustomContainer(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cost.length,
                        itemBuilder: (context, index) {
                          bool isfourthIndex = index == 6;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: cost[index],
                                  style: CustomTextStyle.seemore10,
                                ),
                                CustomText(
                                  text: costDetails[index],
                                  style: isfourthIndex
                                      ? CustomTextStyle.seemore10
                                          .copyWith(color: Colors.green)
                                      : CustomTextStyle.seemore10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    DottedLine(dashColor: Colors.grey.shade500),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Grand Total',
                            style: CustomTextStyle.seemore10,
                          ),
                          CustomText(
                            text: '₹$grandTotal',
                            style: CustomTextStyle.itemBoldText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  CustomContainer foodDesignMethod(List<dynamic> orderDetails, orderType,
      void showImageOverlay(BuildContext context), BuildContext context) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bill Summary', style: CustomTextStyle.detailsTitleText),
            CustomSizedBox(height: 25),
            for (var i = 0; i < orderDetails.length; i++) ...[
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            orderType == 'services'
                                ? GestureDetector(
                                    onTap: () {
                                      showImageOverlay(context);
                                    },
                                    child: SizedBox(
                                      height: 23,
                                      width: 23,
                                      child: Image.asset(
                                          'assets/images/package.png'),
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
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  child: Text(
                                    '${orderDetails[i]['quantity'] ?? ''}  x ${orderDetails[i]['foodName'] ?? ''}',
                                    style: CustomTextStyle.itemBoldText,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        CustomSizedBox(width: 5),
                        Text('₹${orderDetails[i]['foodPrice'] ?? ''} ',
                            style: CustomTextStyle.seemore10),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  CustomContainer parcelDesignMethod(
      void showImageOverlay(BuildContext context),
      BuildContext context,
      parcelImage,
      parcelName) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
  }
}

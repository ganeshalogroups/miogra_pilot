// // ignore_for_file: depend_on_referenced_packages

// import 'package:miogra_service/Controller.dart/ProfileController/depositcontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/depositnodatascreen.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/depositrequestdatscreen.dart';
// import 'package:miogra_service/Shimmer/depositscreenshimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class DepositScreen extends StatefulWidget {
//   final bool isdataUpdate;
//   const DepositScreen({super.key, this.isdataUpdate = true});

//   @override
//   State<DepositScreen> createState() => _DepositScreenState();
// }

// class _DepositScreenState extends State<DepositScreen> {
//   final DepositController getDepositController = Get.put(DepositController());
//   bool hasTransactions = false;
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isdataUpdate == true) {
//       getDepositController.getRequestDepositApi();
//       //getDepositController.getDepositedDepositApi();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 270,
//       child: Column(
//         children: [
//           Obx(() {
//             if (getDepositController.dataRequestLoading.value) {
//               return Center(child: DepositScreenShimmer());
//             }
//             DateTime now = DateTime.now();
//             String formattedStartDateTime =
//                 DateFormat('dd/MM/yyyy').format(now);
//             if (getDepositController.getRequestDeposit.isEmpty) {
//               return DepositNoDataScreen(
//                   formattedDate: formattedStartDateTime.toString());
//             }
//             var depositData = getDepositController.getRequestDeposit.first;
//             var totalAmount =
//                 depositData['amountDetails']?['totalAmount'] ?? '';

//             var depositStatus = depositData['depositStatus'] ?? '';

//             return Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       DepositrequestDatScreen(
//                         depositStatus: depositStatus,
//                         totalAmount: totalAmount.toString(),
//                         formattedStartDateTime:
//                             formattedStartDateTime.toString(),
//                       )
//                     ]));
//           }),

//           // SizedBox(height: MediaQuery.of(context).size.height/1.2,
//           // child:DepositeTransPagin() ,)
//           // Obx(() {
//           //   if (getDepositController.dataDepositedLoading.value) {
//           //     return Center(child: DepositTransactionShimmer());
//           //   }

//           //   if (getDepositController.getDepositedDeposit.isEmpty) {
//           //     return TransactionHistoryNodata();
//           //   }

//           //   return Padding(
//           //     padding: const EdgeInsets.all(15.0),
//           //     child: Column(
//           //       crossAxisAlignment: CrossAxisAlignment.start,
//           //       children: [
//           //         CustomText(
//           //           text: 'Transaction History',
//           //           style: CustomTextStyle.stepTitleText,
//           //         ),
//           //         CustomSizedBox(height: 20),
//           //         SizedBox(
//           //           height:
//           //               getDepositController.getDepositedDeposit.length * 300,
//           //           child: ListView.builder(
//           //             shrinkWrap: true,
//           //             physics: NeverScrollableScrollPhysics(),
//           //             itemCount:
//           //                 getDepositController.getDepositedDeposit.length,
//           //             itemBuilder: (context, index) {
//           //               var transdepositList =
//           //                   getDepositController.getDepositedDeposit;
//           //               var transdeposit = transdepositList[index];
//           //               var totalAmount = transdeposit['amountDetails']
//           //                           ?['totalAmount']
//           //                       .toString() ??
//           //                   '';

//           //               var orderDateTime = transdeposit['createdAt'] ?? '';
//           //               DateTime parsedDate = DateTime.parse(orderDateTime);
//           //               String formattedDate =
//           //                   DateFormat('dd MMMM, yyyy | hh:mm a')
//           //                       .format(parsedDate);

//           //               return InkWell(
//           //                 onTap: () {
//           //                   Navigator.push(
//           //                     context,
//           //                     MaterialPageRoute(
//           //                       builder: (context) => TransactionDetails(
//           //                         transactionDetails: transdeposit,
//           //                       ),
//           //                     ),
//           //                   );
//           //                 },
//           //                 child: Container(
//           //                   margin: const EdgeInsets.symmetric(vertical: 5.0),
//           //                   padding: const EdgeInsets.all(10.0),
//           //                   color: Colors.white60,
//           //                   child: Row(
//           //                     children: [
//           //                       Column(
//           //                         crossAxisAlignment:
//           //                             CrossAxisAlignment.start,
//           //                         children: [
//           //                           CustomText(
//           //                             text: 'UPI Payment',
//           //                             style: CustomTextStyle.stepTitleText,
//           //                           ),
//           //                           CustomText(
//           //                             text: formattedDate,
//           //                             style: CustomTextStyle.identityGreyText,
//           //                           ),
//           //                         ],
//           //                       ),
//           //                       Spacer(),
//           //                       Column(
//           //                         children: [
//           //                           CustomText(
//           //                             text: '₹ $totalAmount',
//           //                             style:
//           //                                 CustomTextStyle.blackboldSmallText,
//           //                           ),
//           //                           CustomText(
//           //                             text: 'Successful',
//           //                             style: CustomTextStyle.greenSuccessText,
//           //                           ),
//           //                         ],
//           //                       ),
//           //                       SizedBox(width: 10),
//           //                       Icon(MdiIcons.chevronRight),
//           //                     ],
//           //                   ),
//           //                 ),
//           //               );
//           //             },
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   );
//           // })
//         ],
//       ),
//     );
//   }
// }

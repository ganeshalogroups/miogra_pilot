import 'dart:io';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_identityproof.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../Controller.dart/AuthController.dart/fileuploadcontroller.dart';

class DepositeUpdateScreen extends StatefulWidget {
  final dynamic data;
  final int index;
  const DepositeUpdateScreen({super.key, this.data, required this.index});

  @override
  State<DepositeUpdateScreen> createState() => _DepositeUpdateScreenState();
}

class _DepositeUpdateScreenState extends State<DepositeUpdateScreen> {
  ImageUploader imageUploader = Get.put(ImageUploader());
  bool _isUploading = false;
  File? proofImage;
  String type = 'bankTransfer';
  @override
  void initState() {
    super.initState();
    print(
      "ffffffffffffffffffffffffff ${widget.data[widget.index]["offlineOrder"].toString()}",
    );
    print(widget.data[widget.index]["amountDetails"]["offlineAmount"]
        .toStringAsFixed(2));

    imageUploader.imageLFURL.value = '';
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:Customcolors.decorationbackground,
//       appBar: AppBar(
//       centerTitle: true,
//        backgroundColor:Customcolors.decorationbackground,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.grey.shade600,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: CustomText(
//           text: 'Deposit',
//           style: CustomTextStyle.stepTitle,
//         ),
//       ),
//       body: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: SingleChildScrollView(
//             child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 CustomText(
//                   text: "Deposite ID ",
//                   style: CustomTextStyle.itemBoldText,
//                 ),
//                 CustomText(
//                   text: "New",
//                   style: CustomTextStyle.starText,
//                 )
//               ]),
//               CustomSizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   cartMethod(
//                       title: "No.of.Orders",
//                       value: widget.data[widget.index]["orderDetails"].length
//                           .toString()),
//                   cartMethod(title: "No.of.COD Orders", value: widget.data[widget.index]["offlineOrder"].toString()),
//                   cartMethod(
//                       title: "Deposite Amount",
//                       value: widget.data[widget.index]["amountDetails"]
//                               ["totalAmount"]
//                           .toString())
//                 ],
//               ),
//               CustomSizedBox(
//                 height: 20,
//               ),
//               CustomText(
//                 text: "Payment Type",
//                 style: CustomTextStyle.itemBoldText,
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Radio<String>(
//                             value: 'others',
//                             groupValue: type,
//                             activeColor: Colors.deepOrange,
//                             onChanged: (String? value) {
//                               setState(() {
//                                 type = value!;
//                               });
//                             }),
//                         CustomText(
//                           text: 'Cash',
//                           style: CustomTextStyle.detailsTitleText,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Radio<String>(
//                           value: 'UPI',
//                           groupValue: type,
//                           activeColor: Colors.deepOrange,
//                           onChanged: (String? value) {
//                             setState(() {
//                               type = value!;
//                             });
//                           },
//                         ),
//                         CustomText(
//                           text: 'UPI',
//                           style: CustomTextStyle.detailsTitleText,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Radio<String>(
//                           value: 'bankTransfer',
//                           groupValue: type,
//                           activeColor: Colors.deepOrange,
//                           onChanged: (String? value) {
//                             setState(() {
//                               type = value!;
//                             });
//                           },
//                         ),
//                         CustomText(
//                           text: 'Bank ',
//                           overflow: TextOverflow.ellipsis,
//                           style: CustomTextStyle.detailsTitleText,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               CustomSizedBox(
//                 height: 10,
//               ),
//               IdentityProof(
//                 onFileChosen: (File? image) async {
//                   if (image != null) {
//                     setState(() {
//                       _isUploading = true;
//                     });
//                     proofImage = image;
//                     final prooffUrl = await imageUploader
//                         .uploadLicenseFrontImage(file: image);

//                     if (prooffUrl != "") {
//                       setState(() {
//                         proofImage = image;
//                         _isUploading = false;
//                       });
//                     } else {
//                       setState(() {
//                         _isUploading = false;
//                       });
//                       // Handle upload failure
//                     }
//                   }
//                 },
//                 label: 'Proof',
//                 // initialFile:
//                 //     File(vehicleRegisterController.licenseFrontUrl.value),
//               ),
//               CustomSizedBox(
//                 height: 20,
//               ),
//               CustomButton(
//                 width: double.infinity,
//                 borderRadius: BorderRadius.circular(20),
//                 onPressed: () {
//                   if (imageUploader.imageLFURL.isEmpty) {
//                     Get.snackbar(
//                       "File Upload Failed",
//                       "Must added proof image",
//                     );
//                   } else {
//                     Provider.of<DepositProviderPagin>(context, listen: false)
//                         .updateDeposit(
//                       context: context,
//                       depositId: widget.data[widget.index]["_id"]
//                           .toString(), // Replace with actual deposit ID
//                       updatedData: {
//                         "depositStatus": "pending",
//                         "paymentType": "bankTransfer",
//                         "proof": imageUploader.imageLFURL.toString()
//                       },
//                     );
//                   }
//                 },
//                 child: CustomText(
//                   text: 'Continue',
//                   style: CustomTextStyle.buttonText,
//                 ),
//               )
//             ],
//           ),
//         )),
//       ),
//     );
//   }

//   cartMethod({String? title, String? value}) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 3.3,
//       color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomText(
//             text: title.toString(),
//             style: CustomTextStyle.smallProfile,
//           ),
//           CustomText(
//             text: value.toString(),
//             style: CustomTextStyle.itemBoldText,
//           )
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Customcolors.decorationbackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Customcolors.decorationbackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Customcolors.decorationGery,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CustomText(
          text: 'Deposit',
          style: CustomTextStyle.stepTitle,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text:
                              "Deposit No: ${widget.data[widget.index]["depositNo"].toString()} ",
                          style: CustomTextStyle.itemBoldText,
                        ),
                        CustomText(
                          text: widget.data[widget.index]["depositStatus"] ==
                                  "failed"
                              ? "Rejected"
                              : widget.data[widget.index]["depositStatus"]
                                  .toString()
                                  .capitalizeFirst
                                  .toString(),
                          style: CustomTextStyle.starText,
                        )
                      ]),
                  const SizedBox(height: 10),

                  /// 🔶 Orange container with white boxes inside
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: Customcolors.darkPurple,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Color(0xFFF98322), // Color code for #F98322
                          Color(0xFFEE4C46), // End color
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _whiteBox(
                              context,
                              title: "No. of Orders",
                              value: widget
                                  .data[widget.index]["orderDetails"].length
                                  .toString(),
                            ),
                            _whiteBox(
                              context,
                              title: "No. of COD Orders",
                              value: widget.data[widget.index]["offlineOrder"]
                                  .toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _whiteBox(
                          context,
                          title: "Deposit Amount",
                          value: widget.data[widget.index]["amountDetails"]
                                  ["offlineAmount"]
                              .toStringAsFixed(2),
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomText(
                    text: "Payment Type",
                    style: CustomTextStyle.itemBoldText,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'others',
                              groupValue: type,
                              activeColor: Customcolors.darkPurple,
                              onChanged: (String? value) {
                                setState(() {
                                  type = value!;
                                });
                              },
                            ),
                            CustomText(
                              text: 'Cash',
                              style: CustomTextStyle.carttblack,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'UPI',
                              groupValue: type,
                              activeColor: Customcolors.darkPurple,
                              onChanged: (String? value) {
                                setState(() {
                                  type = value!;
                                });
                              },
                            ),
                            CustomText(
                              text: 'UPI',
                              style: CustomTextStyle.carttblack,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'bankTransfer',
                              groupValue: type,
                              activeColor: Customcolors.darkPurple,
                              onChanged: (String? value) {
                                setState(() {
                                  type = value!;
                                });
                              },
                            ),
                            CustomText(
                              text: 'Bank ',
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.carttblack,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  IdentityProof(
                    onFileChosen: (File? image) async {
                      if (image != null) {
                        setState(() {
                          _isUploading = true;
                        });
                        proofImage = image;
                        final prooffUrl = await imageUploader
                            .uploadLicenseFrontImage(file: image);

                        if (prooffUrl != "") {
                          setState(() {
                            proofImage = image;
                            _isUploading = false;
                          });
                        } else {
                          setState(() {
                            _isUploading = false;
                          });
                          // Optionally handle upload failure
                        }
                      }
                    },
                    label: 'Upload your Proof:',
                    style: CustomTextStyle.carttblack,
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: CustomButton(
                      width: MediaQuery.of(context).size.width / 2,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: _isUploading
                          ? null
                          : () {
                              if (imageUploader.imageLFURL.isEmpty) {
                                Get.snackbar(
                                  "File Upload Failed",
                                  "Must add proof image",
                                );
                                return;
                              }
                              Provider.of<DepositProviderPagin>(context,
                                      listen: false)
                                  .updateDeposit(
                                context: context,
                                depositId:
                                    widget.data[widget.index]["_id"].toString(),
                                updatedData: {
                                  "depositStatus": "pending",
                                  "paymentType": type,
                                  "proof": imageUploader.imageLFURL.toString(),
                                },
                              );
                            },
                      child: CustomText(
                        text: 'Continue',
                        style: CustomTextStyle.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔲 White Box with shadow for order/deposit stats
  Widget _whiteBox(BuildContext context,
      {required String title, required String value, bool fullWidth = false}) {
    return Container(
      width:
          fullWidth ? double.infinity : MediaQuery.of(context).size.width / 2.4,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: CustomTextStyle.seemore10,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: value,
            style: CustomTextStyle.mediumBoldBlackText,
          ),
        ],
      ),
    );
  }
}

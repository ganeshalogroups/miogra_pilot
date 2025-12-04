import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EarningCountScreen extends StatefulWidget {
  final String totaldeliverycharge;
   final String totaltips;
    final dynamic tripAmount;
   EarningCountScreen({super.key, required this.totaldeliverycharge,required this.totaltips, this.tripAmount});

  @override
  State<EarningCountScreen> createState() => _EarningCountScreenState();
}

class _EarningCountScreenState extends State<EarningCountScreen> {
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());
  @override
  void initState() {
    super.initState();
    profilScreeenController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Shadow color
                  offset: const Offset(
                      0, 4), // Horizontal offset: 0, Vertical offset: 4
                  blurRadius: 1, // Blur radius
                  spreadRadius: 0, // Spread radius
                ),
              ],
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width / 2.3,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    offset: const Offset(
                        0, 4), // Horizontal offset: 0, Vertical offset: 4
                    blurRadius: 1, // Blur radius
                    spreadRadius: 0, // Spread radius
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
              
   Customcolors.lightPurple,
                 
   Customcolors.darkPurple                  ],
                ),
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 6,
                  // ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 20),
                        CustomContainer(
                          // height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            MdiIcons.shoppingOutline,
                            color:               

                 
   Customcolors.darkPurple,
                            size: 17,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                           //   text: widget.totaldeliverycharge,
                              text: widget.tripAmount. toStringAsFixed(2),
                              style:CustomTextStyle.bigwhite,
                            ),
                            CustomText(
                              text: 'Total Trip cost',
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        )
                      ]),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            CustomContainer(
              borderRadius: BorderRadius.circular(15),
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width / 2.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                 
   Customcolors.lightPurple,
                 
   Customcolors.darkPurple

                  ],
                ),
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 // SizedBox(height: 6),
                  // Row(
                  //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     SizedBox(width: 20),
                  //     CustomContainer(
                  //       height: 20,
                  //       width: 20,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.white,
                  //       ),
                  //       child: Icon(
                  //         MdiIcons.clockTimeThreeOutline,
                  //         color: Colors.orange,
                  //         size: 17,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Obx(() {
                  //       if (profilScreeenController.dataLoading.value) {
                  //         return Center(child: SizedBox());
                  //       }
                  //       if (profilScreeenController
                  //           .deliveryManpProfile.isEmpty) {
                  //         return Center(child: Text('No Data Found'));
                  //       }
                  //       var profileData =
                  //           profilScreeenController.deliveryManpProfile.first;
                  //       var activeStatus = profileData['activeStatus'] ?? '';
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           CustomText(
                  //             text:activeStatus ,
                  //             // text: activeStatus == "online"
                  //             //     ? 'Online'
                  //             //     : 'Offline',
                  //             style: TextStyle(
                  //                 fontSize: 16,
                  //                 fontFamily: 'Poppins-Regular',
                  //                 color: Colors.white),
                  //           ),
                  //           CustomText(
                  //             text: 'Active Status',
                  //             style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontFamily: 'Poppins-Regular',
                  //                 color: Colors.white),
                  //           ),
                  //         ],
                  //       );
                  //     })
                  //   ],
                  // ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 20),
                        CustomContainer(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            MdiIcons.wallet,
                            color:              
  
                 
   Customcolors.darkPurple,
                            size: 17,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: widget.totaltips,
                              style:CustomTextStyle.bigwhite,
                            ),
                            CustomText(
                              text: 'Total Tips',
                             style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        )
                      ]),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

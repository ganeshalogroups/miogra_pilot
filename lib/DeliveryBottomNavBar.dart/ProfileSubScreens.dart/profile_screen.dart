// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/AuthScreen.dart/loginscreen.dart';
import 'package:miogra_service/Controller.dart/ProfileController/editprofilecontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/redirectcontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/deposite_trans_paginaton.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/editprofile.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/Shimmer/profilescreenshimmer.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> items = [
    "Edit profile",
   // "Deposit",
    "Privacy Policy",
    "About",
    "Logout"
  ];

  final List<String> imagePaths = [
    'assets/images/deposit.png',
    'assets/images/deposit.png',
    'assets/images/deposit.png',
    'assets/images/about.png',
    'assets/images/signout.png'
  ];

  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());
  final RedirectController redirect = Get.put(RedirectController());
  final EditProfileController editprofilScreeenController =
      Get.put(EditProfileController());

  // final EarningPaginController earningsController =
  //     Get.put(EarningPaginController());

  final EarningsScreen earningsScreen = Get.put(EarningsScreen());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profilScreeenController.getProfile();
      redirect.getredirectDetails();
      // profilScreeenController.getProfile();
    });
  }

  bool switchValueOpenHead = false;
  //bool _isLoading = false;

  // void _toggleSwitch() async {
  //   setState(() {
  //     switchValueOpenHead = !switchValueOpenHead;
  //   });

  //   try {
  //     if (switchValueOpenHead == true) {
  //       if (!await FlutterOverlayWindow.isPermissionGranted()) {
  //         await FlutterOverlayWindow.requestPermission();
  //       }

  //       if (await FlutterOverlayWindow.isPermissionGranted()) {
  //         if (await FlutterOverlayWindow.isActive()) return;
  //         await FlutterOverlayWindow.showOverlay(
  //           alignment: OverlayAlignment.topRight,
  //           enableDrag: true,
  //           overlayTitle: "FastX",
  //           overlayContent: 'Overlay Enabled',
  //           flag: OverlayFlag.defaultFlag,
  //           visibility: NotificationVisibility.visibilityPublic,
  //           positionGravity: PositionGravity.auto,
  //           height: (MediaQuery.of(context).size.height * 0.20).toInt(),
  //           width: 200,
  //           startPosition: const OverlayPosition(10, 60),
  //         );
  //         // await FlutterOverlayWindow.showOverlay(
  //         //   alignment: OverlayAlignment.centerRight,
  //         //   flag: OverlayFlag.defaultFlag,
  //         //   enableDrag: true,
  //         // );
  //       }
  //     } else {
  //       FlutterOverlayWindow.closeOverlay()
  //           .then((value) => print('STOPPED: alue: $value'));
  //     }
  //     //await Future.delayed(Duration(seconds: 1));
  //   } finally {
  //     setState(() {
  //     });
  //   }
  // }

  logoutfunction() {
    editprofilScreeenController.delPartName.value = '';
    editprofilScreeenController.emailId.value = '';
    editprofilScreeenController.mobNumb.value = '';
    editprofilScreeenController.flatNo.value = '';
    editprofilScreeenController.delarea.value = '';
    editprofilScreeenController.nearBy.value = '';
    getStorage.erase();
    mobilenumb = "";
    useremail = "";
    Usertoken;
    UserId;
  }

  String capitalizeFirstLetter(String value) {
    if (value.isEmpty) return '';
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final earningtrip = Provider.of<EarningPaginations>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryBottomNavigation(showBottomSheet: false)));
        return;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DeliveryBottomNavigation(showBottomSheet: false))),
            ),
            title: Center(
                child: CustomText(
              text: 'Profile        ',
              style: CustomTextStyle.screenTitle,
            ))),
        body: Obx(() {
          if (profilScreeenController.dataLoading.value) {
            return Center(child: ProfileScreenShimmer());
          }
          if (profilScreeenController.deliveryManpProfile.isEmpty) {
            return Center(child: Text('No Data Found'));
          }
          var profileData = profilScreeenController.deliveryManpProfile.first;
          var deliveryManId = profileData['uuid'] ?? '';
          var deliveryManName = profileData['name'] ?? '';
          var deliveryManEmail = profileData['email'] ?? '';
          var deliveryManMobile = profileData['mobileNo'] ?? '';
          var deliveryManRegion =
              profileData['regionDetails']?['regionName'] ?? '';
          var deliveryManImage = profileData['imgUrl'] ?? '';
          var deliveryManPincodes =
              profileData['regionDetails']?['regionPincodes'] ?? [];
          var deliveryManRating =
              (profileData['ratingAverage']?.toDouble() ?? 0.0);
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomContainer(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                          

   Color(0xFFAE62E8),
 Color(0xFF623089)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        width: MediaQuery.of(context).size.width / 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.white),
                                          color: Colors.white,
                                          image: deliveryManImage.isNotEmpty
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      "$globalImageUrlLink${deliveryManImage}"),
                                                  fit: BoxFit.cover,
                                                )
                                              : DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/delprofile.png'),
                                                  fit: BoxFit.cover,
                                                )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: capitalizeFirstLetter(
                                                  deliveryManName ?? ''),
                                              style: CustomTextStyle.delName,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: Image.asset(
                                                        'assets/images/rating.png')),
                                                CustomText(
                                                    text:
                                                        '${deliveryManRating.toStringAsFixed(1)}',
                                                    style: CustomTextStyle
                                                        .profilerating),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        CustomText(
                                            text: 'ID: ${deliveryManId ?? ''}',
                                            style: CustomTextStyle
                                                .deliveryBlueText),
                                        CustomSizedBox(height: 8),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.6,
                                          child: CustomText(
                                              text:
                                                  '${deliveryManMobile ?? ''} | ${deliveryManEmail ?? ''}',
                                              overflow: TextOverflow.clip,
                                              style: CustomTextStyle
                                                  .phoneemailText),
                                        ),
                                        CustomSizedBox(height: 6),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  CustomSizedBox(height: 20),
                  CustomContainer(
                    borderRadius: BorderRadius.circular(25),
                    width: MediaQuery.of(context).size.width / 1,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              // InkWell(
                              //   onTap: () {
                              //     FlutterOverlayWindow.closeOverlay().then(
                              //         (value) =>
                              //             print('STOPPED: alue: $value'));
                              //   },
                              //   child: CustomText(
                              //     text: 'Show floating icon',
                              //     style:  CustomTextStyle.smallText
                              //   ),
                              // ),
                              // GestureDetector(
                              //   onTap: _isLoading ? null : _toggleSwitch,
                              //   child: AnimatedContainer(
                              //     duration: Duration(milliseconds: 300),
                              //     width: 60,
                              //     height: 30,
                              //     decoration: BoxDecoration(
                              //       color: switchValueOpenHead
                              //           ? Colors.green
                              //           : Colors.grey,
                              //       borderRadius: BorderRadius.circular(20),
                              //     ),
                              //     child: Stack(
                              //       children: [
                              //         Align(
                              //           alignment: switchValueOpenHead
                              //               ? Alignment.centerRight
                              //               : Alignment.centerLeft,
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(4.0),
                              //             child: Container(
                              //               width: 20,
                              //               height: 20,
                              //               decoration: BoxDecoration(
                              //                 color: Colors.white,
                              //                 borderRadius:
                              //                     BorderRadius.circular(15),
                              //               ),
                              //             ),
                              //           ),
                              //         ),

                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () async {
                              //     if (!await FlutterOverlayWindow
                              //         .isPermissionGranted()) {
                              //       await FlutterOverlayWindow
                              //           .requestPermission();
                              //     }

                              //     if (await FlutterOverlayWindow
                              //         .isPermissionGranted()) {
                              //             if (await FlutterOverlayWindow.isActive())
                              //       return;
                              //     await FlutterOverlayWindow.showOverlay(
                              //         alignment: OverlayAlignment.centerRight,
                              //       enableDrag: true,
                              //       overlayTitle: "FastX",
                              //       overlayContent: 'Overlay Enabled',
                              //       flag: OverlayFlag.defaultFlag,
                              //       visibility:
                              //           NotificationVisibility.visibilityPublic,
                              //       positionGravity: PositionGravity.auto,
                              //       height:
                              //           (MediaQuery.of(context).size.height *
                              //                   0.18)
                              //               .toInt(),
                              //       width: WindowSize.matchParent,
                              //       startPosition:
                              //           const OverlayPosition(0, -259),
                              //     );
                              //       // await FlutterOverlayWindow.showOverlay(
                              //       //   alignment: OverlayAlignment.centerRight,
                              //       //   flag: OverlayFlag.defaultFlag,
                              //       //   enableDrag: true,
                              //       // );
                              //     }

                              //   },
                              //   child: CustomText(
                              //     text: 'Tap Overlay',
                              //     style: CustomTextStyle.regionProfileText,
                              //   ),
                              // ),
                            ],
                          ),
                          CustomSizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  FlutterOverlayWindow.closeOverlay().then(
                                      (value) =>
                                          print('STOPPED: alue: $value'));
                                },
                                child: CustomText(
                                  text: 'Service Region',
                                  style: CustomTextStyle.identityGreyText,
                                ),
                              ),
                            ],
                          ),
                          CustomSizedBox(height: 6),
                          CustomText(
                            text: '${deliveryManRegion ?? ''}',
                            style: CustomTextStyle.regionProfileText,
                          ),
                          CustomSizedBox(height: 20),
                          CustomText(
                              text: 'Pincode',
                              style: CustomTextStyle.identityGreyText),
                          CustomSizedBox(height: 6),
                          CustomText(
                            text: '${deliveryManPincodes.join(', ')}',
                            style: CustomTextStyle.regionProfileText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox(height: 20),
                  CustomContainer(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    // height: MediaQuery.of(context).size.height / 7.2,
                    width: MediaQuery.of(context).size.width / 1,
                    height:
                        items.length * MediaQuery.of(context).size.height / 12,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // if (index == 1) {
                              //   // Navigate to DepositScreen
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => DepositeTransPagin()
                              //         //DepositScreen(),
                              //         ),
                              //   );
                              // }
                                if (index == 1) {
                                for (var item in redirect
                                    .redirectLoadingDetails["data"]) {
                                  if (item["key"] == "privacyLink") {
                                    launchwebUrl(context, item["value"]);

                                    break; // Exit loop once the "whatsappLink" is found and launched
                                  }
                                }
                              } else if (index == 2) {
                                for (var item in redirect
                                    .redirectLoadingDetails["data"]) {
                                  if (item["key"] == "termsandservice") {
                                    launchwebUrl(context, item["value"]);

                                    break; // Exit loop once the "whatsappLink" is found and launched
                                  }
                                }
                              } else if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ),
                                );
                              } else if (index == 3) {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Logout?",
                                              style:
                                                  CustomTextStyle.logoutText),
                                          SizedBox(
                                              height:
                                                  16.0), // Add some spacing between the text and buttons
                                          Text(
                                              "Are you sure you want to logout?",
                                              textAlign: TextAlign.center,
                                              style: CustomTextStyle
                                                  .logoutContent),
                                          SizedBox(
                                              height:
                                                  24.0), // Add some spacing before the buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                      child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                    ),
                                                  )),
                                                ),
                                              ),
                                              CustomButton(
                                                  height: 40,
                                                  width: 100,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  onPressed: () async {
                                                    // Perform logout
                                                    setState(() {
                                                      // Clear all profile data variables
                                                      mobilenumb = '';
                                                      Usertoken = '';
                                                      UserId = '';
                                                      username = '';
                                                    });
                                                    await getStorage.erase();
                                                    setState(() {
                                                      getStorage
                                                          .remove("mobilenumb");
                                                      getStorage
                                                          .remove("Usertoken");
                                                      getStorage
                                                          .remove("UserId");
                                                      getStorage
                                                          .remove("username");

                                                      getStorage.erase();
                                                      profilScreeenController
                                                          .logout();

                                                      editprofilScreeenController
                                                          .clearData();
                                                      earningtrip.clearData();
                                                      logoutfunction();
                                                    });

                                                    Get.offAll(
                                                        () => LoginScreen());
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                // Handle other taps here
                              }
                            },
                            child: ListTile(
                              leading: CustomContainer(
                                height: 25,
                                width: 25,
                                child: Image.asset(
                                  imagePaths[index],
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(items[index],
                                      style: CustomTextStyle.smallText),
                                  Spacer(),
                                  SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: Image.asset(
                                          'assets/images/rightchevron.png'))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void launchwebUrl(BuildContext context, String url) async {
    try {
      await canLaunch(url);
      await launch(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong when launching URL"),
        ),
      );
    }
  }
}

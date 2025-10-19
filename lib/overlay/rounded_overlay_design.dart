
// import 'package:miogra_service/AuthScreen.dart/loginscreen.dart';
// import 'package:miogra_service/Controller.dart/ProfileController/editprofilecontroller.dart';
// import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
// import 'package:miogra_service/Controller.dart/ProfileController/redirectcontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/deposite_trans_paginaton.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/editprofile.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
// import 'package:miogra_service/Shimmer/profilescreenshimmer.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:get/get.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/widgets.dart/custom_container.dart';
// import 'package:miogra_service/widgets.dart/custom_space.dart';
// import 'package:miogra_service/widgets.dart/custom_text.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// class MessangerChatHead extends StatefulWidget {
//   const MessangerChatHead({Key? key}) : super(key: key);

//   @override
//   State<MessangerChatHead> createState() => _MessangerChatHeadState();
// }

// class _MessangerChatHeadState extends State<MessangerChatHead> {
//   Color color = const Color(0xFFFFFFFF);
//   BoxShape _currentShape = BoxShape.circle;
//   static const String _kPortNameOverlay = 'OVERLAY';
//   static const String _kPortNameHome = 'UI';
//   final _receivePort = ReceivePort();
//   SendPort? homePort;
//   String? messageFromOverlay;

//   @override
//   void initState() {
//     super.initState();
//     if (homePort != null) return;
//     final res = IsolateNameServer.registerPortWithName(
//       _receivePort.sendPort,
//       _kPortNameOverlay,
//     );
//     log("$res : HOME");
//     _receivePort.listen((message) {
//       log("message from UI: $message");
//       setState(() {
//         messageFromOverlay = 'message from UI: $message';
//       });
//     });
//   }

//   var targetPackageName = 'com.fastx.consumer';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: MediaQuery.of(context).size.height/1,
//       color: Colors.transparent,
//       //elevation: 0.0,
//       child: GestureDetector(
//         onTap: () async {
//           if (_currentShape == BoxShape.rectangle) {
//             await FlutterOverlayWindow.resizeOverlay(50, 100, true);
//             setState(() {
//               _currentShape = BoxShape.circle;
//             });
//           } else {
//             await FlutterOverlayWindow.resizeOverlay(
//               WindowSize.matchParent,
//               WindowSize.matchParent,
//               false,
//             );
//             setState(() {
//               _currentShape = BoxShape.rectangle;
//             });
//           }
//         },
//         child: Container(
//           // height: 100,
//           //height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             color: Customcolors.decorationpureWhite,
//             shape: _currentShape,
//           ),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 _currentShape == BoxShape.rectangle
//                     ? TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: Colors.black,
//                         ),
//                         onPressed: () async {
//                           try {
//                             if (_currentShape == BoxShape.rectangle) {
//                               await FlutterOverlayWindow.resizeOverlay(
//                                   50, 100, true);
//                               setState(() {
//                                 _currentShape = BoxShape.circle;
//                               });
//                             } else {
//                               await FlutterOverlayWindow.resizeOverlay(
//                                 WindowSize.matchParent,
//                                 WindowSize.matchParent,
//                                 false,
//                               );
//                               setState(() {
//                                 _currentShape = BoxShape.rectangle;
//                               });
//                             }
//                           } catch (e) {
//                             print(e);
//                           }

//                           await LaunchApp.openApp(
//                             androidPackageName: 'com.fastx.courier',
//                             iosUrlScheme: 'pulsesecure://',
//                             appStoreLink:
//                                 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
//                             // openStore: false
//                           );
//                         },
//                         child: const Text("Get back"),
//                       )
//                     :
//                     //Container(height: 300,color: Colors.amber,),
//                     const SizedBox.shrink(),
//                    _currentShape == BoxShape.rectangle
//                     ? messageFromOverlay == null
//                         ?  CustomContainer(
//                                  height: 50,
//                                 width: 50,
//                                   decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                 color: Colors.white,),
//                                   child: ClipOval(
//                                       child:
//                          Image.asset("assets/images/deliverypartnerlogo.png", fit: BoxFit.cover,),),)
//                         : Text(messageFromOverlay ?? '')
//                     : CustomContainer(
//                      decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: Colors.white,),
//                                   height: 50,
//                                 width: 50,
//                                   child: ClipOval(
//                                       child: 
//                          Image.asset("assets/images/deliverypartnerlogo.png", fit: BoxFit.cover,)))
//                     //  Image.asset("assets/images/deliverypartnerlogo.png")
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class _MessangerChatHeadState extends State<MessangerChatHead> {
//   BoxShape _currentShape = BoxShape.circle;
//   static const String _kPortNameOverlay = 'OVERLAY';
//   final _receivePort = ReceivePort();
//   String? messageFromOverlay;

//   @override
//   void initState() {
//     super.initState();
//     if (IsolateNameServer.lookupPortByName(_kPortNameOverlay) == null) {
//       IsolateNameServer.registerPortWithName(
//         _receivePort.sendPort,
//         _kPortNameOverlay,
//       );
//     }
//     _receivePort.listen((message) {
//       setState(() {
//         messageFromOverlay = 'message from UI: $message';
//       });
//     });
//   }

//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping(_kPortNameOverlay);
//     _receivePort.close();
//     super.dispose();
//   }

//   Future<void> toggleOverlaySize() async {
//     if (_currentShape == BoxShape.rectangle) {
//       await FlutterOverlayWindow.resizeOverlay(50, 100, true);
//       setState(() {
//         _currentShape = BoxShape.circle;
//       });
//     } else {
//       await FlutterOverlayWindow.resizeOverlay(
//         WindowSize.matchParent,
//         WindowSize.matchParent,
//         false,
//       );
//       setState(() {
//         _currentShape = BoxShape.rectangle;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleOverlaySize,
//       child: Container(
//         decoration: BoxDecoration(
//           shape: _currentShape,
//           color: Colors.transparent, // <-- Transparent background
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _currentShape == BoxShape.rectangle
//                   ? messageFromOverlay == null
//                       ? GestureDetector(
//                           onTap: () async {
//                             try {
//                               await toggleOverlaySize();
//                             } catch (e) {
//                               print(e);
//                             }
//                             await LaunchApp.openApp(
//                               androidPackageName: 'com.fastx.courier',
//                               iosUrlScheme: 'pulsesecure://',
//                               appStoreLink:
//                                   'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
//                             );
//                               FlutterOverlayWindow.closeOverlay();
//                           },
//                           child: Container(
//   height: 50,
//   width: 50,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.3), // Shadow color
//         blurRadius: 8, // Softness of the shadow
//         offset: Offset(0, 4), // Horizontal & Vertical offset
//       ),
//     ],
//   ),
//   child: ClipOval(
//     child: Image.asset(
//       "assets/images/deliverypartnerlogo.png",
//        height: 50,
//   width: 50,
//       fit: BoxFit.cover,
//     ),
//   ),
// )

//                         )
//                       : Text(messageFromOverlay ?? '')
//                   : Container(
//   height: 50,
//   width: 50,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.3), // Shadow color
//         blurRadius: 8, // Softness of the shadow
//         offset: Offset(0, 4), // Horizontal & Vertical offset
//       ),
//     ],
//   ),
//   child: ClipOval(
//     child: Image.asset(
//       "assets/images/deliverypartnerlogo.png",
//        height: 50,
//   width: 50,
//       fit: BoxFit.cover,
//     ),
//   ),
// )

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





// class _MessangerChatHeadState extends State<MessangerChatHead> {
//   BoxShape _currentShape = BoxShape.circle;
//   static const String _kPortNameOverlay = 'OVERLAY';
//   final _receivePort = ReceivePort();
//   String? messageFromOverlay;

//   @override
//   void initState() {
//     super.initState();

//     // Precache the image to avoid flickering during drag
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       precacheImage(
//         const AssetImage("assets/images/deliverypartnerlogo.png"),
//         context,
//       );
//     });

//     if (IsolateNameServer.lookupPortByName(_kPortNameOverlay) == null) {
//       IsolateNameServer.registerPortWithName(
//         _receivePort.sendPort,
//         _kPortNameOverlay,
//       );
//     }

//     _receivePort.listen((message) {
//       setState(() {
//         messageFromOverlay = 'message from UI: $message';
//       });
//     });
//   }

//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping(_kPortNameOverlay);
//     _receivePort.close();
//     super.dispose();
//   }

//   Future<void> toggleOverlaySize() async {
//     if (_currentShape == BoxShape.rectangle) {
//       await FlutterOverlayWindow.resizeOverlay(50, 100, true);
//       setState(() {
//         _currentShape = BoxShape.circle;
//       });
//     } else {
//       await FlutterOverlayWindow.resizeOverlay(
//         WindowSize.matchParent,
//         WindowSize.matchParent,
//         false,
//       );
//       setState(() {
//         _currentShape = BoxShape.rectangle;
//       });
//     }
//   }

//   Widget buildChatHeadImage() {
//     return RepaintBoundary(
//       child: Container(
//         height: 50,
//         width: 50,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             "assets/images/deliverypartnerlogo.png",
//             height: 50,
//             width: 50,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleOverlaySize,
//       child: Container(
//         decoration: BoxDecoration(
//           shape: _currentShape,
//           color: Colors.transparent,
//         ),
//         child: Center(
//           child: _currentShape == BoxShape.rectangle
//               ? (messageFromOverlay == null
//                   ? GestureDetector(
//                       onTap: () async {
//                         try {
//                           await toggleOverlaySize();
//                         } catch (e) {
//                           debugPrint('Error: $e');
//                         }

//                         await LaunchApp.openApp(
//                           androidPackageName: 'com.fastx.courier',
//                           iosUrlScheme: 'pulsesecure://',
//                           appStoreLink:
//                               'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
//                         );

//                         FlutterOverlayWindow.closeOverlay();
//                       },
//                       child: buildChatHeadImage(),
//                     )
//                   : Text(
//                       messageFromOverlay ?? '',
//                       style: const TextStyle(color: Colors.white),
//                     ))
//               : buildChatHeadImage(),
//         ),
//       ),
//     );
//   }
// }


// class Check extends StatefulWidget {
//   const Check({super.key});

//   @override
//   State<Check> createState() => _CheckState();
// }

// class _CheckState extends State<Check> {

//   @override
//   Widget build(BuildContext context) {
//   void showFloatingOverlay(BuildContext context) async {
//   final isGranted = await FlutterOverlayWindow.isPermissionGranted();
//   if (!isGranted) {
//     // You may prompt the user to allow overlay permission here
//     return;
//   }

//   final isActive = await FlutterOverlayWindow.isActive();
//   if (isActive) return;

//   final overlayHeight = (MediaQuery.of(context).size.height * 0.18).toInt();

//   // Show overlay
//   await FlutterOverlayWindow.showOverlay(
//     alignment: OverlayAlignment.centerRight,
//     enableDrag: true,
//     overlayTitle: "X-SLAYER",
//     overlayContent: 'Overlay Enabled',
//     flag: OverlayFlag.defaultFlag,
//     visibility: NotificationVisibility.visibilityPublic,
//     positionGravity: PositionGravity.auto,
//     height: overlayHeight,
//     width: WindowSize.matchParent,
//     startPosition: const OverlayPosition(0, -259),
//   );
// }
//     return Scaffold(body:   Column(
//                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                             SizedBox(height: 200,),
//                               InkWell(
//                                 onTap: (){
//                                     FlutterOverlayWindow.closeOverlay()
//                     .then((value) => print('STOPPED: alue: $value'));
//                                 },
//                                 child: CustomText(
//                                   text: 'Service Region',
//                                   style: CustomTextStyle.identityGreyText,
//                                 ),
//                               ),
//                                    SizedBox(height: 200,),
//                               InkWell(
//                                 onTap: () async {
//                                  showFloatingOverlay(context);
                                
//                                 },
//                                 child: CustomText(
//                                   text: 'Tap Overlay',
//                                   style: CustomTextStyle.regionProfileText,
//                                 ),
//                               ),
                            
//                             ],
//                           ),
//                          );
//   }
// }
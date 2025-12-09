// ignore_for_file: avoid_print, depend_on_referenced_packages

// import 'package:just_audio/just_audio.dart';
// import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Const.dart/time_convert_values.dart';
// import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
// import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
// import 'package:miogra_service/firebase_options.dart';
// import 'package:miogra_service/overlay/eg.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';

// import 'dart:async';

// final player = AudioPlayer();
// Timer? alarmTimer;

// String? tokenFCM;
//  final ProfilScreeenController profilScreeenController =
//       Get.put(ProfilScreeenController());


// Future<void> _startAlarm() async {
//   try {
//     await player.setAsset('assets/clock_alarm.mp3');
//     await player.setLoopMode(LoopMode.one);
//     player.play();
//     alarmTimer?.cancel();
//     alarmTimer = Timer(const Duration(seconds: 60), () {
//       player.stop();
//     });
//   } catch (e) {
//     print("Alarm play error: $e");
//   }
// }

// void stopAlarm() {
//   player.stop();
//   alarmTimer?.cancel();
// }
// //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//     await GetStorage.init();
   
//   print("Handling a background message: ${message.messageId}");
//   print(message.data);
//  try {
 
//     final storage = GetStorage();
//    // await profilScreeenController.getProfile();
//     bool  isactive = storage.read("isdelactive");
//     bool  isnotify = isactive;
//   //isnotify ? _startAlarm() : stopAlarm();
   
//   // print("DOOLU BOOLU       ${ isnotify}");
//    print("DOOLU BOOLU       ${ isnotify}");
  
//     } catch (e) {
//       print("Error: DOLU BOLU  $e");
//     }


 

//     final storage = GetStorage();
//  bool  isactive = storage.read("isdelactive");
//     bool  isnotify = isactive;
  
//   flutterLocalNotificationsPlugin.show(
//     message.data.hashCode,
//     message.data['title'] ?? "New Order",
//     message.data['body'] ?? "You have a new delivery request",
//     NotificationDetails(
//       android:
//       AndroidNotificationDetails(
//         // channel1.id,
//         // channel1.name,
//         isnotify? 'high_importance_channel': 'normal_alerts',
//         isnotify?  'High Importance Notifications': 'Normal Alerts',
//       //  channelDescription: channel1.description,
//       channelDescription: isnotify? 'Used for order alerts and important updates.': 'Default notification sounds',
//         playSound: true,
//         sound: isnotify?  RawResourceAndroidNotificationSound('clock_alarm') : null,
//         importance: Importance.max,
//         priority: Priority.high,
//         enableVibration: true,
//         ongoing: true, // Keeps it visible until user dismisses
//       ),
//     ),
//   );
// }






// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// final AndroidNotificationChannel channel1 = const AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'Used for order alerts and important updates.',
//   importance: Importance.max,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound('clock_alarm'),
// );

// final AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
//   'normal_alerts',
//   'Normal Alerts',
//   description: 'Default notification sounds',
//   importance: Importance.max,
//   playSound: true,
// );


// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

// // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   FirebaseMessaging.instance.getToken().then((value) {
//     print(' ---FCM--${value.toString()}--');
//     fcmToken = value.toString();
//   });

//   FirebaseMessaging.instance.requestPermission(
//     badge: true,
//     sound: true,
//     alert: true,
//   );
//   ///commented
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   ///
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel1);

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel2);

//   await GetStorage.init();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     Get.put(RegionController());
//     runApp(const MyApp());
//   });
// }


// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MessangerChatHead(),
//      // home: TrueCallerOverlay(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//    currentDateGlobal= TimerdataService().apiselectdateCallDate();
//     // Initialize notification plugin
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(response.payload);
//         String? targetScreen = response.payload;
//         if (targetScreen != null && targetScreen != "none") {
//         Get.to(() =>     RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));
//           // Get.off(() => TripSummary(
//           //       id: response.payload.toString(),
//           //       orderId: "",
//           //     ));
//           //handleNotificationNavigation(response.payload);
//         }
//       },
//     );



//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📲 App opened via notification");
//       String? targetScreen = message.data['screen']; // Example key

//       if (targetScreen != null && targetScreen != "none") {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(targetScreen);
//        Get.to(() =>  RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));

//          _startAlarm();
//         // Get.off(() => TripSummary(
//         //       id: targetScreen.toString(),
//         //       orderId: "",
//         //     ));
//       }
//     });

//     // Listen to FCM messages when app is in foreground

    
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async{


//         //final stopwatch = Stopwatch()..start();

//  // Timer.periodic(Duration(seconds: 1), (timer) async {
//     // if (stopwatch.elapsed.inSeconds >= 60) {
//     //   timer.cancel();
//     //   print("Completed 60 seconds!");
//     //   return;
//     // }

//     try {
//     bool  isactive =  profilScreeenController.isactive.value;
//     await profilScreeenController.getProfile();
//   isactive ? _startAlarm() : stopAlarm();
//    //isactive ? _startAlarm() : stopAlarm();
//    print("OOOO AAALALALALALALALALAL        ${ isactive}");
//   // print("OOOO AAALALALALALALALALAL       $isactive");
//     } catch (e) {
//       print("Error: $e");
//     }
// //  });
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
// print("QWNNNNNNNN   $notification");
//       if (notification != null && android != null) {
       

//         flutterLocalNotificationsPlugin.show(
//   notification.hashCode,
//   notification.title ?? "Notification",
//   notification.body,
//   payload: message.data['screen'].toString(),
//   NotificationDetails(
//     android: AndroidNotificationDetails(
//       channel1.id,
//       channel1.name,
//       channelDescription: channel1.description,
//       playSound: profilScreeenController.isactive.value,
//       sound: profilScreeenController.isactive.value?  RawResourceAndroidNotificationSound('clock_alarm') : RawResourceAndroidNotificationSound('silent'),
//       importance: Importance.max,
//       priority: Priority.high,
//     ),
//   ),
// );

                   




//  //_startAlarm();
  
//         // Show custom AlertDialog (only one!)
//         BuildContext? dialogContext = Get.context;
//         if (dialogContext != null) {
//            showDialog(
//   context: dialogContext,
//   builder: (_) => Theme(
//     data: ThemeData(
//     //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
//     ),
//     child: Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//               width: MediaQuery.of(context).size.width * 0.75, // 👈 Set dialog width
//             padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
           
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//                 const SizedBox(height: 10),
//                Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CustomButton(
//                     width: 100,
//                     borderRadius: BorderRadius.circular(20),
//                     onPressed: (){

//                       print("SSSSSSSssssss   ${notification.title}");
//                       print("SSSSSSSssssss   ${notification.body}");

  
// stopAlarm();

//                                             Get.to(() =>   RestaurentBottomSheet(
//                                 onReachedRestaurant: () {},
//                                 reachedDelLocation: false,
//                                 deltype: "",
//                                 id: message.data['screen'].toString(),
//                                 orderId: "",
//                                 onBackPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ));
//                     },
//                     child: Text(
//                       'Ok',
//                       style: CustomTextStyle.updateButtonText,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Close icon button
//           Positioned(
//             top: -5,
//             right: -5,
//             child: Container(
//               height: 35,
//               width: 35,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade300,
//               ), 
//               child: IconButton(
//                 icon: Icon(Icons.close,size: 20,),
//                 onPressed: () => Navigator.of(dialogContext).pop(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );  

//         } else {
//           print("⚠️ Get.context is null, dialog not shown");
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(notification.title.toString()),
//                 content: Text(notification.body.toString()),
//               );
//             },
//           );
//         }
//       }
     
//     });
//   }






//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     var initializationSettingsAndroid =
//   //         AndroidInitializationSettings('@mipmap/ic_launcher');
//   //     var initializationSettings =
//   //         InitializationSettings(android: initializationSettingsAndroid);

//   //     flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   //     // Listen to FCM messages when the app is in the foreground
//   //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //       RemoteNotification? notification = message.notification;
//   //       AndroidNotification? android = message.notification?.android;

//   //       if (notification != null && android != null) {
//   //         // Show a local notification
//   //         flutterLocalNotificationsPlugin.show(
//   //           notification.hashCode,
//   //           notification.title,
//   //           notification.body,
//   //           payload: 'Default_Sound',
//   //           NotificationDetails(
//   //             android: AndroidNotificationDetails(
//   //               channel.id,
//   //               channel.name,
//   //               playSound: true,
//   //               enableVibration: true,
//   //               showWhen: true,

//   //               // Uncomment and replace with actual sound resource if needed
//   //               // sound: RawResourceAndroidNotificationSound('default_notification_sound'),
//   //             ),
//   //           ),
//   //         );

//   //         // Show a dialog with the notification details
//   //         showDialog(
//   //           context: context,
//   //           builder: (context) {
//   //             return AlertDialog(
//   //               title: Text(notification.title.toString()),
//   //               content: Text(notification.body.toString()),
//   //             );
//   //           },
//   //         );
//   //       }
//   //     });
//   //   });
//   // }

//   // This widget is the root of your application.





//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveApp(builder: (BuildContext context) {
//       return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => EarningPaginations()),
//           ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
//         ],
//         child: GetMaterialApp(
//           builder: (BuildContext context, Widget? child) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaler: const TextScaler.linear(1.0),
//               ),
//               child: child!,
//             );
//           },
//           title: 'FastX-Partner',
//           theme: ThemeData(
//             fontFamily: 'Poppins-Regular',
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           debugShowCheckedModeBanner: false,
//           home:
//               // StepTabBar(
//               //   loginMobileNumb:"7010230486",
//               // )

//               SplashScreen(),
//         ),
//       );
//     });
//   }
// }












































































// //First Code


// // ignore_for_file: avoid_print, depend_on_referenced_packages

// import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Const.dart/time_convert_values.dart';
// import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
// import 'package:miogra_service/firebase_options.dart';
// import 'package:miogra_service/overlay/eg.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';

// String? tokenFCM;

// //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// //background design  notification
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   print("Handling a background message: ${message.messageId}");
// //   print(message.data);
// //   flutterLocalNotificationsPlugin.show(
// //       message.data.hashCode,
// //       message.data['title'],
// //       message.data['body'],
// //       NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           channel.id,
// //           channel.name,
// //           playSound: true,
// //           sound: RawResourceAndroidNotificationSound(
// //               'custom_notification_sound'), // Set custom sound
// //           importance: Importance.max,
// //           priority: Priority.high,
// //           // sound: RawResourceAndroidNotificationSound("default_notification_sound"),
// //          //playSound: true
// //         ),
// //       ));
// //   if (message.notification != null) {}
// //   if (message.data != null) {
// //     String messageText = message.data['message'] ?? 'Empty message';
// //   }
// // }

// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // name
//   description: 'This channel is used for important notifications.',
//   importance: Importance.max,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound(
//       'custom_notification_sound'), // Your sound file name without extension

//   // 'high_importance_channel', // id
//   // 'High Importance Notifications', // title, // description
//   // importance: Importance.max,
//   // playSound: true
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

// // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   FirebaseMessaging.instance.getToken().then((value) {
//     print(' ---FCM--${value.toString()}--');
//     fcmToken = value.toString();
//   });

//   FirebaseMessaging.instance.requestPermission(
//     badge: true,
//     sound: true,
//     alert: true,
//   );
//   ///commented
// //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   ///
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await GetStorage.init();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     Get.put(RegionController());
//     runApp(const MyApp());
//   });
// }


// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MessangerChatHead(),
//      // home: TrueCallerOverlay(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//    currentDateGlobal= TimerdataService().apiselectdateCallDate();
//     // Initialize notification plugin
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(response.payload);
//         String? targetScreen = response.payload;
//         if (targetScreen != null && targetScreen != "none") {
//         Get.to(() =>     RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));
//           // Get.off(() => TripSummary(
//           //       id: response.payload.toString(),
//           //       orderId: "",
//           //     ));
//           //handleNotificationNavigation(response.payload);
//         }
//       },
//     );
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📲 App opened via notification");
//       String? targetScreen = message.data['screen']; // Example key

//       if (targetScreen != null && targetScreen != "none") {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(targetScreen);
//        Get.to(() =>  RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));
//         // Get.off(() => TripSummary(
//         //       id: targetScreen.toString(),
//         //       orderId: "",
//         //     ));
//       }
//     });

//     // Listen to FCM messages when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {
//         // Show system tray notification
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title ?? "Notification",
//           notification.body,
//           payload: message.data['screen'].toString(),
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               playSound: true,
//               enableVibration: true,
//               showWhen: true,
//             ),
//           ),
//         );

//         // Show custom AlertDialog (only one!)
//         BuildContext? dialogContext = Get.context;
//         if (dialogContext != null) {
//            showDialog(
//   context: dialogContext,
//   builder: (_) => Theme(
//     data: ThemeData(
//     //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
//     ),
//     child: Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//               width: MediaQuery.of(context).size.width * 0.75, // 👈 Set dialog width
//             padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             // padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//                 const SizedBox(height: 10),
//                Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CustomButton(
//                     width: 100,
//                     borderRadius: BorderRadius.circular(20),
//                     onPressed: (){
//                                             Get.to(() =>   RestaurentBottomSheet(
//                                 onReachedRestaurant: () {},
//                                 reachedDelLocation: false,
//                                 deltype: "",
//                                 id: message.data['screen'].toString(),
//                                 orderId: "",
//                                 onBackPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ));
//                     },
//                     child: Text(
//                       'Ok',
//                       style: CustomTextStyle.updateButtonText,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Close icon button
//           Positioned(
//             top: -5,
//             right: -5,
//             child: Container(
//               height: 35,
//               width: 35,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade300,
//               ), 
//               child: IconButton(
//                 icon: Icon(Icons.close,size: 20,),
//                 onPressed: () => Navigator.of(dialogContext).pop(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );  

//           // showDialog(
//           //   context: dialogContext,
//           //   builder: (_) => Theme(
//           //     data: ThemeData(dialogTheme: DialogTheme(backgroundColor: Colors.white)),
//           //     child: AlertDialog(
//           //     surfaceTintColor: Colors.white,
//           //       title: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//           //            IconButton(
//           //   icon: Icon(Icons.close, ),
//           //   onPressed: () => Navigator.of(dialogContext).pop(),
//           // ),
//           //         ],
//           //       ),
//           //       content: Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//           //       actions: [
//           //        Center(
//           //          child: CustomButton(
//           //               width: 100,
//           //                   borderRadius:BorderRadius.circular(20),
//           //                   onPressed: () {
//           //                   Get.to(() =>   RestaurentBottomSheet(
//           //                       onReachedRestaurant: () {},
//           //                       reachedDelLocation: false,
//           //                       deltype: "",
//           //                       id: message.data['screen'].toString(),
//           //                       orderId: "",
//           //                       onBackPressed: () {
//           //                         Navigator.pop(context);
//           //                       },
//           //                     ));
//           //                   },
//           //                   child: Text('Ok',style: CustomTextStyle.updateButtonText,),
//           //                   //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //                 ),
//           //        ),
//           //         // Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //         //   children: [
//           //         //     CustomButton(
//           //         //     width: 80,
//           //         //         borderRadius:BorderRadius.circular(20),
//           //         //         onPressed: () {
//           //         //         Get.to(() =>   RestaurentBottomSheet(
//           //         //             onReachedRestaurant: () {},
//           //         //             reachedDelLocation: false,
//           //         //             deltype: "",
//           //         //             id: message.data['screen'].toString(),
//           //         //             orderId: "",
//           //         //             onBackPressed: () {
//           //         //               Navigator.pop(context);
//           //         //             },
//           //         //           ));
//           //         //         },
//           //         //         child: Text('Ok',style: CustomTextStyle.updateButtonText,),
//           //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //         //       ),
//           //         //       CustomButton(
//           //         //         borderRadius:BorderRadius.circular(20),
//           //         //         onPressed: () {
//           //         //         // Navigator.pop(context);
//           //         //         Navigator.pop(dialogContext);

//           //         //         },
//           //         //         child: Text('Close',style: CustomTextStyle.updateButtonText,),
//           //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //         //       ),
//           //         //   ],
//           //         // ),
               
//           //       ],
//           //     ),
//           //   ),
//           // );
//         } else {
//           print("⚠️ Get.context is null, dialog not shown");
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(notification.title.toString()),
//                 content: Text(notification.body.toString()),
//               );
//             },
//           );
//         }
//       }
//       // showDialog(
//       //   context: context,
//       //   builder: (context) {
//       //     return AlertDialog(
//       //       title: Text(notification!.title ?? 'New Notification'),
//       //       content: Text(notification.body ?? 'You have a new message.'),
//       //     );
//       //   },
//       // );
//     });
//   }
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     var initializationSettingsAndroid =
//   //         AndroidInitializationSettings('@mipmap/ic_launcher');
//   //     var initializationSettings =
//   //         InitializationSettings(android: initializationSettingsAndroid);

//   //     flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   //     // Listen to FCM messages when the app is in the foreground
//   //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //       RemoteNotification? notification = message.notification;
//   //       AndroidNotification? android = message.notification?.android;

//   //       if (notification != null && android != null) {
//   //         // Show a local notification
//   //         flutterLocalNotificationsPlugin.show(
//   //           notification.hashCode,
//   //           notification.title,
//   //           notification.body,
//   //           payload: 'Default_Sound',
//   //           NotificationDetails(
//   //             android: AndroidNotificationDetails(
//   //               channel.id,
//   //               channel.name,
//   //               playSound: true,
//   //               enableVibration: true,
//   //               showWhen: true,

//   //               // Uncomment and replace with actual sound resource if needed
//   //               // sound: RawResourceAndroidNotificationSound('default_notification_sound'),
//   //             ),
//   //           ),
//   //         );

//   //         // Show a dialog with the notification details
//   //         showDialog(
//   //           context: context,
//   //           builder: (context) {
//   //             return AlertDialog(
//   //               title: Text(notification.title.toString()),
//   //               content: Text(notification.body.toString()),
//   //             );
//   //           },
//   //         );
//   //       }
//   //     });
//   //   });
//   // }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveApp(builder: (BuildContext context) {
//       return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => EarningPaginations()),
//           ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
//         ],
//         child: GetMaterialApp(
//           builder: (BuildContext context, Widget? child) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaler: const TextScaler.linear(1.0),
//               ),
//               child: child!,
//             );
//           },
//           title: 'FastX-Partner',
//           theme: ThemeData(
//             fontFamily: 'Poppins-Regular',
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           debugShowCheckedModeBanner: false,
//           home:
//               // StepTabBar(
//               //   loginMobileNumb:"7010230486",
//               // )

//               SplashScreen(),
//         ),
//       );
//     });
//   }
// }










// //Second Code


// // ignore_for_file: avoid_print, depend_on_referenced_packages

// import 'package:just_audio/just_audio.dart';
// import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Const.dart/time_convert_values.dart';
// import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
// import 'package:miogra_service/firebase_options.dart';
// import 'package:miogra_service/overlay/eg.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';

// import 'dart:async';

// final player = AudioPlayer();
// Timer? alarmTimer;

// String? tokenFCM;



// // Future<void> _startAlarm() async {
// //   try {
// //     await player.setAsset('assets/clock_alarm.mp3');
// //     await player.setLoopMode(LoopMode.one);
// //     player.play();
// //     alarmTimer?.cancel();
// //     alarmTimer = Timer(const Duration(seconds: 60), () {
// //       player.stop();
// //     });
// //   } catch (e) {
// //     print("Alarm play error: $e");
// //   }
// // }

// Future<void> _startAlarm() async {
//   try {
//      if (player.playing) {
//   await player.stop();
// }
// await player.setAsset('assets/clock_alarm.mp3');
// await player.play();

//   } catch (e) {
//     print("Alarm play error: $e");
//   }
// }


// void stopAlarm() {
//   player.stop();
//    alarmTimer?.cancel();
// }
// //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   print(message.data);

//   flutterLocalNotificationsPlugin.show(
//     message.data.hashCode,
//     message.data['title'] ?? "New Order",
//     message.data['body'] ?? "You have a new delivery request",
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound('clock_alarm'),
//         importance: Importance.max,
//         priority: Priority.high,
//         enableVibration: true,
//         ongoing: true, // Keeps it visible until user dismisses
//       ),
//     ),
//   );
// }

// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'Used for order alerts and important updates.',
//   importance: Importance.max,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound('clock_alarm'),
// );
// final AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
//   'foreground_channel',
//   'Foreground Notifications',
//   description: 'Silent system notification when app is open',
//   importance: Importance.max,
//   playSound: false, // 🚫 disables system sound in foreground
// );



// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

// // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   FirebaseMessaging.instance.getToken().then((value) {
//     print(' ---FCM--${value.toString()}--');
//     fcmToken = value.toString();
//   });

//   FirebaseMessaging.instance.requestPermission(
//     badge: true,
//     sound: true,
//     alert: true,
//   );
//   ///commented
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   ///
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel2);

 

//   await GetStorage.init();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     Get.put(RegionController());
//     runApp(const MyApp());
//   });
// }


// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MessangerChatHead(),
//      // home: TrueCallerOverlay(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//    currentDateGlobal= TimerdataService().apiselectdateCallDate();
//     // Initialize notification plugin
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(response.payload);
//         String? targetScreen = response.payload;
//         if (targetScreen != null && targetScreen != "none") {
//         Get.to(() =>     RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));
//           // Get.off(() => TripSummary(
//           //       id: response.payload.toString(),
//           //       orderId: "",
//           //     ));
//           //handleNotificationNavigation(response.payload);
//         }
//       },
//     );



//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📲 App opened via notification");
//       String? targetScreen = message.data['screen']; // Example key

//       if (targetScreen != null && targetScreen != "none") {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(targetScreen);
//        Get.to(() =>  RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));

//      //    _startAlarm();

//         // Get.off(() => TripSummary(
//         //       id: targetScreen.toString(),
//         //       orderId: "",
//         //     ));
//       }
//     });

//     // Listen to FCM messages when app is in foreground

    
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {




//         // Show system tray notification
       
//         // flutterLocalNotificationsPlugin.show(
//         //   notification.hashCode,
//         //   notification.title ?? "Notification",
//         //   notification.body,
//         //   payload: message.data['screen'].toString(),
//         //   NotificationDetails(
//         //     android: AndroidNotificationDetails(
//         //       channel.id,
//         //       channel.name,
//         //    //   playSound: true,
//         //       playSound: false,
//         //       enableVibration: true,
//         //       showWhen: true,
//         //     ),
//         //   ),
//         // );






// // Dont Play


//         flutterLocalNotificationsPlugin.show(
//   notification.hashCode,
//  notification.title ?? "Notification",
//   notification.body,
//   payload: message.data['screen'].toString(),
//   NotificationDetails(
//     android: AndroidNotificationDetails(
//        channel2.id,
//        channel2.name,
//        channelDescription: channel2.description,
//        playSound: false,
//       //sound:RawResourceAndroidNotificationSound('clock_alarm') ,
    
//       importance: Importance.max,
//       priority: Priority.high,
//     ),
//   ),
  
// );

//  _startAlarm();
  
//         // Show custom AlertDialog (only one!)
//         BuildContext? dialogContext = Get.context;
//         if (dialogContext != null) {
      
//            showDialog(
//   context: dialogContext,
//   builder: (_) => Theme(
//     data: ThemeData(
//     //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
//     ),
//     child: Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//               width: MediaQuery.of(context).size.width * 0.75, // 👈 Set dialog width
//             padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             // padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//                 const SizedBox(height: 10),
//                Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CustomButton(
//                     width: 100,
//                     borderRadius: BorderRadius.circular(20),
//                     onPressed: (){

//                       print("SSSSSSSssssss   ${notification.title}");
//                       print("SSSSSSSssssss   ${notification.body}");
                      
//                    stopAlarm();


//                                             Get.to(() =>   RestaurentBottomSheet(
//                                 onReachedRestaurant: () {},
//                                 reachedDelLocation: false,
//                                 deltype: "",
//                                 id: message.data['screen'].toString(),
//                                 orderId: "",
//                                 onBackPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ));
//                     },
//                     child: Text(
//                       'Ok',
//                       style: CustomTextStyle.updateButtonText,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Close icon button
//           Positioned(
//             top: -5,
//             right: -5,
//             child: Container(
//               height: 35,
//               width: 35,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade300,
//               ), 
//               child: IconButton(
//                 icon: Icon(Icons.close,size: 20,),
//                 onPressed: (){ 
//                   stopAlarm();
//                   Navigator.of(dialogContext).pop();}
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );  

//           // showDialog(
//           //   context: dialogContext,
//           //   builder: (_) => Theme(
//           //     data: ThemeData(dialogTheme: DialogTheme(backgroundColor: Colors.white)),
//           //     child: AlertDialog(
//           //     surfaceTintColor: Colors.white,
//           //       title: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//           //            IconButton(
//           //   icon: Icon(Icons.close, ),
//           //   onPressed: () => Navigator.of(dialogContext).pop(),
//           // ),
//           //         ],
//           //       ),
//           //       content: Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//           //       actions: [
//           //        Center(
//           //          child: CustomButton(
//           //               width: 100,
//           //                   borderRadius:BorderRadius.circular(20),
//           //                   onPressed: () {
//           //                   Get.to(() =>   RestaurentBottomSheet(
//           //                       onReachedRestaurant: () {},
//           //                       reachedDelLocation: false,
//           //                       deltype: "",
//           //                       id: message.data['screen'].toString(),
//           //                       orderId: "",
//           //                       onBackPressed: () {
//           //                         Navigator.pop(context);
//           //                       },
//           //                     ));
//           //                   },
//           //                   child: Text('Ok',style: CustomTextStyle.updateButtonText,),
//           //                   //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //                 ),
//           //        ),
//           //         // Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //         //   children: [
//           //         //     CustomButton(
//           //         //     width: 80,
//           //         //         borderRadius:BorderRadius.circular(20),
//           //         //         onPressed: () {
//           //         //         Get.to(() =>   RestaurentBottomSheet(
//           //         //             onReachedRestaurant: () {},
//           //         //             reachedDelLocation: false,
//           //         //             deltype: "",
//           //         //             id: message.data['screen'].toString(),
//           //         //             orderId: "",
//           //         //             onBackPressed: () {
//           //         //               Navigator.pop(context);
//           //         //             },
//           //         //           ));
//           //         //         },
//           //         //         child: Text('Ok',style: CustomTextStyle.updateButtonText,),
//           //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //         //       ),
//           //         //       CustomButton(
//           //         //         borderRadius:BorderRadius.circular(20),
//           //         //         onPressed: () {
//           //         //         // Navigator.pop(context);
//           //         //         Navigator.pop(dialogContext);

//           //         //         },
//           //         //         child: Text('Close',style: CustomTextStyle.updateButtonText,),
//           //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //         //       ),
//           //         //   ],
//           //         // ),
               
//           //       ],
//           //     ),
//           //   ),
//           // );
//         } else {
//           print("⚠️ Get.context is null, dialog not shown");
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(notification.title.toString()),
//                 content: Text(notification.body.toString()),
//               );
//             },
//           );
//         }
//       }
//       // showDialog(
//       //   context: context,
//       //   builder: (context) {
//       //     return AlertDialog(
//       //       title: Text(notification!.title ?? 'New Notification'),
//       //       content: Text(notification.body ?? 'You have a new message.'),
//       //     );
//       //   },
//       // );
//     }
//     );
//   }
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     var initializationSettingsAndroid =
//   //         AndroidInitializationSettings('@mipmap/ic_launcher');
//   //     var initializationSettings =
//   //         InitializationSettings(android: initializationSettingsAndroid);

//   //     flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   //     // Listen to FCM messages when the app is in the foreground
//   //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //       RemoteNotification? notification = message.notification;
//   //       AndroidNotification? android = message.notification?.android;

//   //       if (notification != null && android != null) {
//   //         // Show a local notification
//   //         flutterLocalNotificationsPlugin.show(
//   //           notification.hashCode,
//   //           notification.title,
//   //           notification.body,
//   //           payload: 'Default_Sound',
//   //           NotificationDetails(
//   //             android: AndroidNotificationDetails(
//   //               channel.id,
//   //               channel.name,
//   //               playSound: true,
//   //               enableVibration: true,
//   //               showWhen: true,

//   //               // Uncomment and replace with actual sound resource if needed
//   //               // sound: RawResourceAndroidNotificationSound('default_notification_sound'),
//   //             ),
//   //           ),
//   //         );

//   //         // Show a dialog with the notification details
//   //         showDialog(
//   //           context: context,
//   //           builder: (context) {
//   //             return AlertDialog(
//   //               title: Text(notification.title.toString()),
//   //               content: Text(notification.body.toString()),
//   //             );
//   //           },
//   //         );
//   //       }
//   //     });
//   //   });
//   // }

//   // This widget is the root of your application.





//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveApp(builder: (BuildContext context) {
//       return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => EarningPaginations()),
//           ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
//         ],
//         child: GetMaterialApp(
//           builder: (BuildContext context, Widget? child) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaler: const TextScaler.linear(1.0),
//               ),
//               child: child!,
//             );
//           },
//           title: 'FastX-Partner',
//           theme: ThemeData(
//             fontFamily: 'Poppins-Regular',
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           debugShowCheckedModeBanner: false,
//           home:
//               // StepTabBar(
//               //   loginMobileNumb:"7010230486",
//               // )

//               SplashScreen(),
//         ),
//       );
//     });
//   }
// }










// import 'package:just_audio/just_audio.dart';
// import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Const.dart/time_convert_values.dart';
// import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
// import 'package:miogra_service/firebase_options.dart';
// import 'package:miogra_service/overlay/eg.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';

// import 'dart:async';

// AudioPlayer? player;

// String? lastBgMessageId;   // 💾 stores last background message id

// String? tokenFCM;


// Future<void> _startAlarm() async {
//   try {
//     print("🔔 Starting alarm...");

//     // Dispose previous player safely
//     if (player != null) {
//       try {
//         await player!.stop();
//         await player!.dispose();
//       } catch (_) {}
//     }

//     // New player instance
//     player = AudioPlayer();

//     // Delay FIXES most timing problems
//     await Future.delayed(const Duration(milliseconds: 150));

//     await player!.setAsset('assets/clock_alarm.wav');
//     await player!.play();

//   } catch (e) {
//     print("❌ Alarm play error: $e");
//   }
// }

// void stopAlarm() {
//   try {
//     if (player != null) {
//       player!.stop();
//       player!.dispose();
//       player = null;
//       print("🛑 Alarm stopped and disposed");
//     }
//   } catch (e) {
//     print("❌ Error stopping alarm: $e");
//   }
// }

// Future<void> _preloadSound() async {
//   final p = AudioPlayer();
//   try {
//     await p.setAsset('assets/clock_alarm.wav');  // warm up decoder
//     await p.stop();
//   } catch (_) {}
//   await p.dispose();
//   print("🎵 Alarm sound preloaded");
// }


// //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   print(message.data);

//  // Ignore image prefetch messages (they contain no title/body/messageId)
// if (!message.data.containsKey("messageId") ||
//     !message.data.containsKey("title") ||
//     !message.data.containsKey("body")) {
//   print("⚠️ Ignored image-prefetch/background utility message");
//   return;
// }

// String messageId = message.data['messageId']!;

// // Duplicate protection
// if (lastBgMessageId == messageId) {
//   print("🔁 Duplicate BACKGROUND notification skipped");
//   return;
// }

// lastBgMessageId = messageId;

//   print("🆕 New BACKGROUND message: $messageId");

// //   flutterLocalNotificationsPlugin.show(
// //      message.data.hashCode,
  
// //     message.data['title'] ?? "New Order",
// //     message.data['body'] ?? "You have a new delivery request",
// //     NotificationDetails(
// //       android: AndroidNotificationDetails(
// //         channel.id,
// //         channel.name,
// //         channelDescription: channel.description,
// //         playSound: false,
// //         //sound: RawResourceAndroidNotificationSound('clock_alarm'),
// //         importance: Importance.max,
// //         priority: Priority.high,
// //         enableVibration: true,
// //         ongoing: true, // Keeps it visible until user dismisses
// //       ),
// //     ),
// //  );
// }

// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'Used for order alerts and important updates.',
//   importance: Importance.max,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound('clock_alarm'),
// );
// final AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
//   'foreground_channel',
//   'Foreground Notifications',
//   description: 'Silent system notification when app is open',
//   importance: Importance.max,
//   playSound: false, // 🚫 disables system sound in foreground
// );



// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

// // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   FirebaseMessaging.instance.getToken().then((value) {
//     print(' ---FCM--${value.toString()}--');
//     fcmToken = value.toString();
//   });

//   FirebaseMessaging.instance.requestPermission(
//     badge: true,
//     sound: true,
//     alert: true,
//   );
//   ///commented
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   ///
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel2);

 

//   await GetStorage.init();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     Get.put(RegionController());
//     runApp(const MyApp());
//   });
// }


// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MessangerChatHead(),
//      // home: TrueCallerOverlay(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//       _preloadSound();
//    currentDateGlobal= TimerdataService().apiselectdateCallDate();
//     // Initialize notification plugin
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(response.payload);
//         String? targetScreen = response.payload;
//         if (targetScreen != null && targetScreen != "none") {
//         Get.to(() =>     RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));
//           // Get.off(() => TripSummary(
//           //       id: response.payload.toString(),
//           //       orderId: "",
//           //     ));
//           //handleNotificationNavigation(response.payload);
//         }
//       },
//     );



//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📲 App opened via notification");
//       String? targetScreen = message.data['screen']; // Example key

//       if (targetScreen != null && targetScreen != "none") {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(targetScreen);
//        Get.to(() =>  RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));

//      //    _startAlarm();

//         // Get.off(() => TripSummary(
//         //       id: targetScreen.toString(),
//         //       orderId: "",
//         //     ));
//       }
//     });

//     // Listen to FCM messages when app is in foreground

    
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {


//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {




//         // Show system tray notification
       
//         // flutterLocalNotificationsPlugin.show(
//         //   notification.hashCode,
//         //   notification.title ?? "Notification",
//         //   notification.body,
//         //   payload: message.data['screen'].toString(),
//         //   NotificationDetails(
//         //     android: AndroidNotificationDetails(
//         //       channel.id,
//         //       channel.name,
//         //    //   playSound: true,
//         //       playSound: false,
//         //       enableVibration: true,
//         //       showWhen: true,
//         //     ),
//         //   ),
//         // );






// // Dont Play


//         flutterLocalNotificationsPlugin.show(
//   notification.hashCode,
//  notification.title ?? "Notification",
//   notification.body??"New TriP Started",
//   payload: message.data['screen'].toString(),
//   NotificationDetails(
//     android: AndroidNotificationDetails(
//        channel2.id,
//        channel2.name,
//        channelDescription: channel2.description,
//        playSound: false,
//       //sound:RawResourceAndroidNotificationSound('clock_alarm') ,
    
//       importance: Importance.max,
//       priority: Priority.high,
//     ),
//   ),
  
// );

//  _startAlarm();

//   // final isForeground =
//   //       WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

//   //   if (isForeground) {
//   //     print("📱 App is in FOREGROUND → play manual sound");
//   //      _startAlarm();        // custom sound (just_audio)
//   //   } else {
//   //     print("📴 App NOT in foreground → skip manual sound");
//   //     // Background notification will play its own sound from FCM payload
//   //   }
  
//         // Show custom AlertDialog (only one!)
//         BuildContext? dialogContext = Get.context;
//         if (dialogContext != null) {
      
//            showDialog(
//   context: dialogContext,
//   builder: (_) => Theme(
//     data: ThemeData(
//     //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
//     ),
//     child: Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//               width: MediaQuery.of(context).size.width * 0.75, // 👈 Set dialog width
//             padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             // padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//                 const SizedBox(height: 10),
//                Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CustomButton(
//                     width: 100,
//                     borderRadius: BorderRadius.circular(20),
//                     onPressed: (){

//                       print("SSSSSSSssssss   ${notification.title}");
//                       print("SSSSSSSssssss   ${notification.body}");
                      
//                    stopAlarm();


//                                             Get.to(() =>   RestaurentBottomSheet(
//                                 onReachedRestaurant: () {},
//                                 reachedDelLocation: false,
//                                 deltype: "",
//                                 id: message.data['screen'].toString(),
//                                 orderId: "",
//                                 onBackPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ));
//                     },
//                     child: Text(
//                       'Ok',
//                       style: CustomTextStyle.updateButtonText,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Close icon button
//           Positioned(
//             top: -5,
//             right: -5,
//             child: Container(
//               height: 35,
//               width: 35,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade300,
//               ), 
//               child: IconButton(
//                 icon: Icon(Icons.close,size: 20,),
//                 onPressed: (){ 
//                   stopAlarm();
//                   Navigator.of(dialogContext).pop();}
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );  

//           // showDialog(
//           //   context: dialogContext,
//           //   builder: (_) => Theme(
//           //     data: ThemeData(dialogTheme: DialogTheme(backgroundColor: Colors.white)),
//           //     child: AlertDialog(
//           //     surfaceTintColor: Colors.white,
//           //       title: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//           //            IconButton(
//           //   icon: Icon(Icons.close, ),
//           //   onPressed: () => Navigator.of(dialogContext).pop(),
//           // ),
//           //         ],
//           //       ),
//           //       content: Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//           //       actions: [
//           //        Center(
//           //          child: CustomButton(
//           //               width: 100,
//           //                   borderRadius:BorderRadius.circular(20),
//           //                   onPressed: () {
//           //                   Get.to(() =>   RestaurentBottomSheet(
//           //                       onReachedRestaurant: () {},
//           //                       reachedDelLocation: false,
//           //                       deltype: "",
//           //                       id: message.data['screen'].toString(),
//           //                       orderId: "",
//           //                       onBackPressed: () {
//           //                         Navigator.pop(context);
//           //                       },
//           //                     ));
//           //                   },
//           //                   child: Text('Ok',style: CustomTextStyle.updateButtonText,),
//           //                   //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //                 ),
//           //        ),
//           //         // Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //         //   children: [
//           //         //     CustomButton(
//           //         //     width: 80,
//           //         //         borderRadius:BorderRadius.circular(20),
//           //         //         onPressed: () {
//           //         //         Get.to(() =>   RestaurentBottomSheet(
//           //         //             onReachedRestaurant: () {},
//           //         //             reachedDelLocation: false,
//           //         //             deltype: "",
//           //         //             id: message.data['screen'].toString(),
//           //         //             orderId: "",
//           //         //             onBackPressed: () {
//           //         //               Navigator.pop(context);
//           //         //             },
//           //         //           ));
//           //         //         },
//           //         //         child: Text('Ok',style: CustomTextStyle.updateButtonText,),
//           //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //         //       ),
//           //         //       CustomButton(
//           //         //         borderRadius:BorderRadius.circular(20),
//           //         //         onPressed: () {
//           //         //         // Navigator.pop(context);
//           //         //         Navigator.pop(dialogContext);

//           //         //         },
//           //         //         child: Text('Close',style: CustomTextStyle.updateButtonText,),
//           //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
//           //         //       ),
//           //         //   ],
//           //         // ),
               
//           //       ],
//           //     ),
//           //   ),
//           // );
//         } else {
//           print("⚠️ Get.context is null, dialog not shown");
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(notification.title.toString()),
//                 content: Text(notification.body.toString()),
//               );
//             },
//           );
//         }
//       }
//       // showDialog(
//       //   context: context,
//       //   builder: (context) {
//       //     return AlertDialog(
//       //       title: Text(notification!.title ?? 'New Notification'),
//       //       content: Text(notification.body ?? 'You have a new message.'),
//       //     );
//       //   },
//       // );
//     }
//     );
//   }
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     var initializationSettingsAndroid =
//   //         AndroidInitializationSettings('@mipmap/ic_launcher');
//   //     var initializationSettings =
//   //         InitializationSettings(android: initializationSettingsAndroid);

//   //     flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   //     // Listen to FCM messages when the app is in the foreground
//   //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //       RemoteNotification? notification = message.notification;
//   //       AndroidNotification? android = message.notification?.android;

//   //       if (notification != null && android != null) {
//   //         // Show a local notification
//   //         flutterLocalNotificationsPlugin.show(
//   //           notification.hashCode,
//   //           notification.title,
//   //           notification.body,
//   //           payload: 'Default_Sound',
//   //           NotificationDetails(
//   //             android: AndroidNotificationDetails(
//   //               channel.id,
//   //               channel.name,
//   //               playSound: true,
//   //               enableVibration: true,
//   //               showWhen: true,

//   //               // Uncomment and replace with actual sound resource if needed
//   //               // sound: RawResourceAndroidNotificationSound('default_notification_sound'),
//   //             ),
//   //           ),
//   //         );

//   //         // Show a dialog with the notification details
//   //         showDialog(
//   //           context: context,
//   //           builder: (context) {
//   //             return AlertDialog(
//   //               title: Text(notification.title.toString()),
//   //               content: Text(notification.body.toString()),
//   //             );
//   //           },
//   //         );
//   //       }
//   //     });
//   //   });
//   // }

//   // This widget is the root of your application.





//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveApp(builder: (BuildContext context) {
//       return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => EarningPaginations()),
//           ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
//         ],
//         child: GetMaterialApp(
//           builder: (BuildContext context, Widget? child) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaler: const TextScaler.linear(1.0),
//               ),
//               child: child!,
//             );
//           },
//           title: 'FastX-Partner',
//           theme: ThemeData(
//             fontFamily: 'Poppins-Regular',
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           debugShowCheckedModeBanner: false,
//           home:
//               // StepTabBar(
//               //   loginMobileNumb:"7010230486",
//               // )

//               SplashScreen(),
            
//         ),
//       );
//     });
//   }
// }


























// import 'package:just_audio/just_audio.dart';
// import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Const.dart/time_convert_values.dart';
// import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
// import 'package:miogra_service/firebase_options.dart';
// import 'package:miogra_service/overlay/eg.dart';
// import 'package:miogra_service/widgets.dart/custom_button.dart';
// import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';

// import 'dart:async';

// final AudioPlayer alarmPlayer = AudioPlayer();
// bool isAlarmPlaying = false;



// String? lastBgMessageId;   // 💾 stores last background message id

// String? tokenFCM;

// Future<void> startAlarm() async {
//   try {
//     if (isAlarmPlaying) return; // avoid duplicate start

//     print("🔔 Starting alarm...");

//     await alarmPlayer.seek(Duration.zero);
//     await alarmPlayer.play();

//     isAlarmPlaying = true;

//   } catch (e) {
//     print("❌ Alarm play error: $e");
//   }
// }

// Future<void> stopAlarm() async {
//   try {
//     await alarmPlayer.stop();
//     isAlarmPlaying = false;
//     print("🛑 Alarm stopped");
//   } catch (e) {
//     print("❌ Error stopping alarm: $e");
//   }
// }

// Future<void> preloadAlarmSound() async {
//   try {
//     await alarmPlayer.setAsset('assets/clock_alarm.wav');
//     print("🎵 Alarm sound preloaded & ready");
//   } catch (e) {
//     print("❌ Preload failed: $e");
//   }
// }
// Future<void> askNotificationPermission() async {
//   final status = await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     criticalAlert: true,
//     provisional: false,
//   );

//   print("🔔 Notification Permission = ${status.authorizationStatus}");
// }


// //////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   print(message.data);

//  // Ignore image prefetch messages (they contain no title/body/messageId)
// if (!message.data.containsKey("messageId") ||
//     !message.data.containsKey("title") ||
//     !message.data.containsKey("body")) {
//   print("⚠️ Ignored image-prefetch/background utility message");
//   return;
// }

// String messageId = message.data['messageId']!;

// // Duplicate protection
// if (lastBgMessageId == messageId) {
//   print("🔁 Duplicate BACKGROUND notification skipped");
//   return;
// }

// lastBgMessageId = messageId;

//   print("🆕 New BACKGROUND message: $messageId");

// }

// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'Used for order alerts and important updates.',
//   importance: Importance.max,
//   playSound: true,
//   sound: RawResourceAndroidNotificationSound('clock_alarm'),
// );
// final AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
//   'foreground_channel',
//   'Foreground Notifications',
//   description: 'Silent system notification when app is open',
//   importance: Importance.max,
//   playSound: true, // 🚫 disables system sound in foreground

// );



// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

// // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//   FirebaseMessaging.instance.getToken().then((value) {
//     print(' ---FCM--${value.toString()}--');
//     fcmToken = value.toString();
//   });

//   FirebaseMessaging.instance.requestPermission(
//     badge: true,
//     sound: true,
//     alert: true,
//   );
//   ///commented
// FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   ///
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel2);

 

//   await GetStorage.init();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     Get.put(RegionController());
//     runApp(const MyApp());
//   });
// }


// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MessangerChatHead(),
//      // home: TrueCallerOverlay(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//      WidgetsBinding.instance.addPostFrameCallback((_) {
//        askNotificationPermission(); 
//     preloadAlarmSound();
//   });

//    currentDateGlobal= TimerdataService().apiselectdateCallDate();
//     // Initialize notification plugin
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(response.payload);
//         String? targetScreen = response.payload;
//         if (targetScreen != null && targetScreen != "none") {
//         Get.to(() =>     RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));
        
//         }
//       },
//     );



//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📲 App opened via notification");
//       String? targetScreen = message.data['screen']; // Example key

//       if (targetScreen != null && targetScreen != "none") {
//         print("+++++++++++++++++++++++++++++++++++++++++++++");
//         print(targetScreen);
//        Get.to(() =>  RestaurentBottomSheet(
//           onReachedRestaurant: () {},
//           reachedDelLocation: false,
//           deltype: "",
//           id: targetScreen.toString(),
//           orderId: "",
//           onBackPressed: () {
//             Navigator.pop(context);
//           },
//         ));

    
//       }
//     });

 

    
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {


//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {






//         flutterLocalNotificationsPlugin.show(
//   notification.hashCode,
//  notification.title ?? "Notification",
//   notification.body??"New TriP Started",
//   payload: message.data['screen'].toString(),
//   NotificationDetails(
//     android: AndroidNotificationDetails(
//        channel2.id,
//        channel2.name,
//        channelDescription: channel2.description,
//        playSound: false,
//       //sound:RawResourceAndroidNotificationSound('clock_alarm') ,
    
//       importance: Importance.max,
//       priority: Priority.high,
//     ),
//   ),
  
// );
// Future.delayed(const Duration(milliseconds: 150), () {
//   startAlarm();
// });

//  // startAlarm();    

//   // final isForeground =
//   //       WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

//   //   if (isForeground) {
//   //     print("📱 App is in FOREGROUND → play manual sound");
//   //      startAlarm();        // custom sound (just_audio)
//   //   } else {
//   //      startAlarm();   
//   //     print("📴 App NOT in foreground → skip manual sound");
//   //     // Background notification will play its own sound from FCM payload
//   //   }
  
//         // Show custom AlertDialog (only one!)
//         BuildContext? dialogContext = Get.context;
//         if (dialogContext != null) {
      
//            showDialog(
//   context: dialogContext,
//   builder: (_) => Theme(
//     data: ThemeData(
//     //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
//     ),
//     child: Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//               width: MediaQuery.of(context).size.width * 0.75, // 👈 Set dialog width
//             padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             // padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
//                 const SizedBox(height: 10),
//                Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CustomButton(
//                     width: 100,
//                     borderRadius: BorderRadius.circular(20),
//                     onPressed: (){

//                       print("SSSSSSSssssss   ${notification.title}");
//                       print("SSSSSSSssssss   ${notification.body}");
                      
//                    stopAlarm();


//                                             Get.to(() =>   RestaurentBottomSheet(
//                                 onReachedRestaurant: () {},
//                                 reachedDelLocation: false,
//                                 deltype: "",
//                                 id: message.data['screen'].toString(),
//                                 orderId: "",
//                                 onBackPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ));
//                     },
//                     child: Text(
//                       'Ok',
//                       style: CustomTextStyle.updateButtonText,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Close icon button
//           Positioned(
//             top: -5,
//             right: -5,
//             child: Container(
//               height: 35,
//               width: 35,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade300,
//               ), 
//               child: IconButton(
//                 icon: Icon(Icons.close,size: 20,),
//                 onPressed: (){ 
//                   stopAlarm();
//                   Navigator.of(dialogContext).pop();}
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );  

//         } else {
//           print("⚠️ Get.context is null, dialog not shown");
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(notification.title.toString()),
//                 content: Text(notification.body.toString()),
//               );
//             },
//           );
//         }
//       }
     
//     }
//     );
//   }
 



//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveApp(builder: (BuildContext context) {
//       return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => EarningPaginations()),
//           ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
//         ],
//         child: GetMaterialApp(
//           builder: (BuildContext context, Widget? child) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaler: const TextScaler.linear(1.0),
//               ),
//               child: child!,
//             );
//           },
//           title: 'FastX-Partner',
//           theme: ThemeData(
//             fontFamily: 'Poppins-Regular',
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           debugShowCheckedModeBanner: false,
//           home:
            

//               SplashScreen(),
            
//         ),
//       );
//     });
//   }
// }






































import 'package:just_audio/just_audio.dart';
import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
import 'package:miogra_service/Controller.dart/ProfileController/editprofilecontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
import 'package:miogra_service/firebase_options.dart';
import 'package:miogra_service/notification.dart';
import 'package:miogra_service/overlay/eg.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';

import 'dart:async';

// final AudioPlayer alarmPlayer = AudioPlayer();
// bool isAlarmPlaying = false;



String? lastBgMessageId;   // 💾 stores last background message id
bool isDialogOpen = false;

String? tokenFCM;

// Future<void> startAlarm() async {
//   try {
//     if (isAlarmPlaying) return; // avoid duplicate start

//     print("🔔 Starting alarm...");

//     await alarmPlayer.seek(Duration.zero);
//     await alarmPlayer.play();

//     isAlarmPlaying = true;

//   } catch (e) {
//     print("❌ Alarm play error: $e");
//   }
// }

// Future<void> stopAlarm() async {
//   try {
//     await alarmPlayer.stop();
//     isAlarmPlaying = false;
//     print("🛑 Alarm stopped");
//   } catch (e) {
//     print("❌ Error stopping alarm: $e");
//   }
// }

// Future<void> preloadAlarmSound() async {
//   try {
//     await alarmPlayer.setAsset('assets/clock_alarm.wav');
//     print("🎵 Alarm sound preloaded & ready");
//   } catch (e) {
//     print("❌ Preload failed: $e");
//   }
// }
Future<void> askNotificationPermission() async {
  final status = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    criticalAlert: true,
    provisional: false,
  );

  print("🔔 Notification Permission = ${status.authorizationStatus}");
}


//////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print(message.data);

 // Ignore image prefetch messages (they contain no title/body/messageId)
if (!message.data.containsKey("messageId") ||
    !message.data.containsKey("title") ||
    !message.data.containsKey("body")) {
  print("⚠️ Ignored image-prefetch/background utility message");
  return;
}

String messageId = message.data['messageId']!;

// Duplicate protection
if (lastBgMessageId == messageId) {
  print("🔁 Duplicate BACKGROUND notification skipped");
  return;
}

lastBgMessageId = messageId;

  print("🆕 New BACKGROUND message: $messageId");

}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

final AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Used for order alerts and important updates.',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('clock_alarm'),
);



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  FirebaseMessaging.instance.getToken().then((value) {
    print(' ---FCM--${value.toString()}--');
    fcmToken = value.toString();
  });

  FirebaseMessaging.instance.requestPermission(
    badge: true,
    sound: true,
    alert: true,
  );
  ///commented
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  ///
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  
 

  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    Get.put(RegionController());
    runApp(const MyApp());
  });
}


@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessangerChatHead(),
     // home: TrueCallerOverlay(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 final EditProfileController _profileUpdateController =
      Get.put(EditProfileController());
void _showOrderDialog(RemoteMessage message, NotificationController notify) {
   
  // showDialog(
  //   context: Get.context!,
  //   builder: (ctx) {
  //     return AlertDialog(
  //       title: Text(message.notification?.title ?? "New Notification"),
  //       content: Text(message.notification?.body ?? "You have a new alert"),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             notify.stopSound();
  //             Navigator.pop(ctx);
  //           },
  //           child: Text("Stop"),
  //         )
  //       ],
  //     );
  //   },
  // );


 if (isDialogOpen) return; // ⛔ block second dialog

  isDialogOpen = true;

             showDialog(
  context: Get.context!,
  builder: (ctx) {
    return Theme(
    data: ThemeData(
    //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
    ),
    child: Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      child: Container(
          width: MediaQuery.of(ctx).size.width * 0.75, // 👈 Set dialog width
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        // padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
          // Text( 'New Notification',style:CustomTextStyle.normalmediumText),
          Text(message.notification?.title ?? "New Notification",style:CustomTextStyle.normalmediumText),
            const SizedBox(height: 10),
          // Text( 'You have a new message.',style:CustomTextStyle.tripText),
           Text(message.notification?.body ?? "You have a new alert",style:CustomTextStyle.tripText),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                 // width: 100,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (){
                
                notify.stopSound();
                              Navigator.pop(ctx);
                    
                 
                
                if(message.notification?.body =="Time to hit the road again new."){
               
    Get.to(() =>   RestaurentBottomSheet(
                              onReachedRestaurant: () {},
                              reachedDelLocation: false,
                              deltype: "",
                              id: message.data['screen'].toString(),
                              orderId: "",
                              onBackPressed: () {
                                
                              },
                            ));
                }
                else{
                     _profileUpdateController.updateProfileforTravel();
                   Get.to(() =>  DeliveryBottomNavigation(showBottomSheet: false,));
                }
                                      
                  },
                  child: Text(
                    'Ok',
                    style: CustomTextStyle.updateButtonText,
                  ),
                ),
                CustomButton(
                 // width: 100,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (){
               
                notify.stopSound();
                           Navigator.pop(ctx);    
                    
                 
                
                
                  },
                  child: Text(
                    'Cancel',
                    style: CustomTextStyle.updateButtonText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  
  }
).then((_) {
    isDialogOpen = false; // ✅ reset
    notify.stopSound();
  }); 
}




  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       askNotificationPermission(); 
   // preloadAlarmSound();
  });
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  final notify = Provider.of<NotificationController>(
      Get.context!,
      listen: false);

  notify.playSound();

  _showOrderDialog(message, notify);
});

   currentDateGlobal= TimerdataService().apiselectdateCallDate();
    // Initialize notification plugin
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        print(response.payload);
        String? targetScreen = response.payload;
        if (targetScreen != null && targetScreen != "none") {
        Get.to(() =>     RestaurentBottomSheet(
          onReachedRestaurant: () {},
          reachedDelLocation: false,
          deltype: "",
          id: targetScreen.toString(),
          orderId: "",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ));
        
        }
      },
    );



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 App opened via notification");
      String? targetScreen = message.data['screen']; // Example key

      if (targetScreen != null && targetScreen != "none") {
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        print(targetScreen);
       Get.to(() =>  RestaurentBottomSheet(
          onReachedRestaurant: () {},
          reachedDelLocation: false,
          deltype: "",
          id: targetScreen.toString(),
          orderId: "",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ));

    
      }
    }

 

    
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {


     

     






// Future.delayed(const Duration(milliseconds: 150), () {
//   startAlarm();
// });

//         BuildContext? dialogContext = Get.context;
//         if (dialogContext != null) {
      
//            showDialog(
//   context: dialogContext,
//   builder: (_) => Theme(
//     data: ThemeData(
   
//     ),
//     child: Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//               width: MediaQuery.of(context).size.width * 0.75, 
//             padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
          
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text( 'New Notification',style:CustomTextStyle.normalmediumText),
//                 const SizedBox(height: 10),
//                Text( 'You have a new message.',style:CustomTextStyle.tripText),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CustomButton(
//                     width: 100,
//                     borderRadius: BorderRadius.circular(20),
//                     onPressed: (){

                     
//                    stopAlarm();


//                                             Get.to(() =>   RestaurentBottomSheet(
//                                 onReachedRestaurant: () {},
//                                 reachedDelLocation: false,
//                                 deltype: "",
//                                 id: message.data['screen'].toString(),
//                                 orderId: "",
//                                 onBackPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               ));
//                     },
//                     child: Text(
//                       'Ok',
//                       style: CustomTextStyle.updateButtonText,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Close icon button
//           Positioned(
//             top: -5,
//             right: -5,
//             child: Container(
//               height: 35,
//               width: 35,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade300,
//               ), 
//               child: IconButton(
//                 icon: Icon(Icons.close,size: 20,),
//                 onPressed: (){ 
//                   stopAlarm();
//                   Navigator.of(dialogContext).pop();}
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );  

//         } else {
//           print("⚠️ Get.context is null, dialog not shown");
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(""),
//                 content: Text(""),
//               );
//             },
//           );
//         }
  
//     }
    );
  }
 



  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => EarningPaginations()),
          ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
           ChangeNotifierProvider(
    create: (_) => NotificationController()),
        ],
        child: GetMaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          title: 'Miogra Pilot',
          theme: ThemeData(
            fontFamily: 'Poppins-Regular',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home:
            

              SplashScreen(),
            
        ),
      );
    });
  }
}



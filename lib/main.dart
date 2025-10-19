// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'package:miogra_service/AuthScreen.dart/splashscreen.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/restaurent_bottomsheet.dart';
import 'package:miogra_service/firebase_options.dart';
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

String? tokenFCM;

//////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//background design  notification
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   print(message.data);
//   flutterLocalNotificationsPlugin.show(
//       message.data.hashCode,
//       message.data['title'],
//       message.data['body'],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound(
//               'custom_notification_sound'), // Set custom sound
//           importance: Importance.max,
//           priority: Priority.high,
//           // sound: RawResourceAndroidNotificationSound("default_notification_sound"),
//           // playSound: true
//         ),
//       ));
//   if (message.notification != null) {}
//   if (message.data != null) {
//     String messageText = message.data['message'] ?? 'Empty message';
//   }
// }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // name
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound(
      'custom_notification_sound'), // Your sound file name without extension

  // 'high_importance_channel', // id
  // 'High Importance Notifications', // title, // description
  // importance: Importance.max,
  // playSound: true
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
  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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
  @override
  @override
  void initState() {
    super.initState();
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
          // Get.off(() => TripSummary(
          //       id: response.payload.toString(),
          //       orderId: "",
          //     ));
          //handleNotificationNavigation(response.payload);
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
        // Get.off(() => TripSummary(
        //       id: targetScreen.toString(),
        //       orderId: "",
        //     ));
      }
    });

    // Listen to FCM messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Show system tray notification
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title ?? "Notification",
          notification.body,
          payload: message.data['screen'].toString(),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,
              enableVibration: true,
              showWhen: true,
            ),
          ),
        );

        // Show custom AlertDialog (only one!)
        BuildContext? dialogContext = Get.context;
        if (dialogContext != null) {
           showDialog(
  context: dialogContext,
  builder: (_) => Theme(
    data: ThemeData(
    //  dialogTheme: DialogTheme(backgroundColor: Colors.white),
    ),
    child: Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.75, // 👈 Set dialog width
            padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            // padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
                const SizedBox(height: 10),
               Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
                const SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    width: 100,
                    borderRadius: BorderRadius.circular(20),
                    onPressed: (){
                                            Get.to(() =>   RestaurentBottomSheet(
                                onReachedRestaurant: () {},
                                reachedDelLocation: false,
                                deltype: "",
                                id: message.data['screen'].toString(),
                                orderId: "",
                                onBackPressed: () {
                                  Navigator.pop(context);
                                },
                              ));
                    },
                    child: Text(
                      'Ok',
                      style: CustomTextStyle.updateButtonText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close icon button
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ), 
              child: IconButton(
                icon: Icon(Icons.close,size: 20,),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);  

          // showDialog(
          //   context: dialogContext,
          //   builder: (_) => Theme(
          //     data: ThemeData(dialogTheme: DialogTheme(backgroundColor: Colors.white)),
          //     child: AlertDialog(
          //     surfaceTintColor: Colors.white,
          //       title: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(notification.title ?? 'New Notification',style:CustomTextStyle.normalmediumText),
          //            IconButton(
          //   icon: Icon(Icons.close, ),
          //   onPressed: () => Navigator.of(dialogContext).pop(),
          // ),
          //         ],
          //       ),
          //       content: Text(notification.body ?? 'You have a new message.',style:CustomTextStyle.tripText),
          //       actions: [
          //        Center(
          //          child: CustomButton(
          //               width: 100,
          //                   borderRadius:BorderRadius.circular(20),
          //                   onPressed: () {
          //                   Get.to(() =>   RestaurentBottomSheet(
          //                       onReachedRestaurant: () {},
          //                       reachedDelLocation: false,
          //                       deltype: "",
          //                       id: message.data['screen'].toString(),
          //                       orderId: "",
          //                       onBackPressed: () {
          //                         Navigator.pop(context);
          //                       },
          //                     ));
          //                   },
          //                   child: Text('Ok',style: CustomTextStyle.updateButtonText,),
          //                   //  onPressed: () => Navigator.of(dialogContext).pop(),
          //                 ),
          //        ),
          //         // Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         //   children: [
          //         //     CustomButton(
          //         //     width: 80,
          //         //         borderRadius:BorderRadius.circular(20),
          //         //         onPressed: () {
          //         //         Get.to(() =>   RestaurentBottomSheet(
          //         //             onReachedRestaurant: () {},
          //         //             reachedDelLocation: false,
          //         //             deltype: "",
          //         //             id: message.data['screen'].toString(),
          //         //             orderId: "",
          //         //             onBackPressed: () {
          //         //               Navigator.pop(context);
          //         //             },
          //         //           ));
          //         //         },
          //         //         child: Text('Ok',style: CustomTextStyle.updateButtonText,),
          //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
          //         //       ),
          //         //       CustomButton(
          //         //         borderRadius:BorderRadius.circular(20),
          //         //         onPressed: () {
          //         //         // Navigator.pop(context);
          //         //         Navigator.pop(dialogContext);

          //         //         },
          //         //         child: Text('Close',style: CustomTextStyle.updateButtonText,),
          //         //         //  onPressed: () => Navigator.of(dialogContext).pop(),
          //         //       ),
          //         //   ],
          //         // ),
               
          //       ],
          //     ),
          //   ),
          // );
        } else {
          print("⚠️ Get.context is null, dialog not shown");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: Text(notification.body.toString()),
              );
            },
          );
        }
      }
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text(notification!.title ?? 'New Notification'),
      //       content: Text(notification.body ?? 'You have a new message.'),
      //     );
      //   },
      // );
    });
  }
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     var initializationSettingsAndroid =
  //         AndroidInitializationSettings('@mipmap/ic_launcher');
  //     var initializationSettings =
  //         InitializationSettings(android: initializationSettingsAndroid);

  //     flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //     // Listen to FCM messages when the app is in the foreground
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification?.android;

  //       if (notification != null && android != null) {
  //         // Show a local notification
  //         flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           payload: 'Default_Sound',
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               channel.id,
  //               channel.name,
  //               playSound: true,
  //               enableVibration: true,
  //               showWhen: true,

  //               // Uncomment and replace with actual sound resource if needed
  //               // sound: RawResourceAndroidNotificationSound('default_notification_sound'),
  //             ),
  //           ),
  //         );

  //         // Show a dialog with the notification details
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: Text(notification.title.toString()),
  //               content: Text(notification.body.toString()),
  //             );
  //           },
  //         );
  //       }
  //     });
  //   });
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => EarningPaginations()),
          ChangeNotifierProvider(create: (context) => DepositProviderPagin()),
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
          title: 'FastX-Partner',
          theme: ThemeData(
            fontFamily: 'Poppins-Regular',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home:
              // StepTabBar(
              //   loginMobileNumb:"7010230486",
              // )

              SplashScreen(),
        ),
      );
    });
  }
}

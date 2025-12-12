import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class MessangerChatHead extends StatefulWidget {
  const MessangerChatHead({super.key});

  @override
  State<MessangerChatHead> createState() => _MessangerChatHeadState();
}

class _MessangerChatHeadState extends State<MessangerChatHead> {
  BoxShape _currentShape = BoxShape.circle;
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? messageFromOverlay;

  @override
  void initState() {
    super.initState();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
    log("$res : HOME");
    _receivePort.listen((message) {
      log("message from UI: $message");
      setState(() {
        messageFromOverlay = 'message from UI: $message';
        _currentShape = BoxShape.circle;
      });
    });
  }

  Future<void> toggleOverlaySize() async {
    if (_currentShape == BoxShape.rectangle) {
      await FlutterOverlayWindow.resizeOverlay(50, 100, true);
      setState(() {
        _currentShape = BoxShape.circle;
      });
    } else {
      await FlutterOverlayWindow.resizeOverlay(
        50,
        100,
        false,
      );
      setState(() {
        _currentShape = BoxShape.circle;
        //_currentShape = BoxShape.rectangle;
      });
    }
  }

  Widget buildChatHeadImage() {
    return SizedBox(
      height: 110,
      width: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Chat head image
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/1024 fill.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Close icon overlay
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                FlutterOverlayWindow.closeOverlay()
                    .then((value) => print('STOPPED: alue: $value'));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> toggleOverlayShapeAndLaunchApp() async {
  //   try {
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

  //       // Launch the app when expanded
  //       await LaunchApp.openApp(
  //         androidPackageName: 'com.fastx.courier',
  //         iosUrlScheme: 'pulsesecure://',
  //         appStoreLink:
  //             'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
  //       );
  //     }
  //   } catch (e) {
  //     print("Error toggling overlay or launching app: $e");
  //   }
  // }
  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleOverlaySize,
      child: Container(
        decoration: BoxDecoration(
          shape: _currentShape,
          color: Colors.transparent,
        ),
        height: _currentShape == BoxShape.circle
            ? 50
            : 250, // size changes based on shape
        width: _currentShape == BoxShape.circle ? 50 : 250,
        child: Center(
            child: GestureDetector(
          onTap: () async {
            await LaunchApp.openApp(
              androidPackageName: 'com.fastx.courier',
              // iosUrlScheme: 'pulsesecure://',
              // appStoreLink:
              //     'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
            );
            //   try {
            //   await toggleOverlaySize();
            // } catch (e) {
            //   debugPrint('Error: $e');
            // }

            // FlutterOverlayWindow.closeOverlay();
            // setState(() {
            //   switchValueOpenHead = false;
            // });
          },
          child: buildChatHeadImage(), // your reference image widget here
        )
            // circle mode uses the same image widget
            ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: toggleOverlayShapeAndLaunchApp,
  //     child: Container(
  //       height: 50,
  //       width: 50,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         image: const DecorationImage(
  //           image: AssetImage('assets/images/deliverypartnerlogo.png'),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}





// class MessangerChatHead extends StatefulWidget {
//   const MessangerChatHead({Key? key}) : super(key: key);

//   @override
//   State<MessangerChatHead> createState() => _MessangerChatHeadState();
// }


// class _MessangerChatHeadState extends State<MessangerChatHead> {
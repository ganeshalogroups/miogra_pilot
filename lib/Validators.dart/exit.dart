 

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ExitApp {
 
  static DateTime? currentBackPressTime;
 
  static Future<void> handlePop() async {
 
    DateTime now = DateTime.now();
 
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds:2)) {
       
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Double tap to Exit');
 
    } else {
 
      SystemNavigator.pop();
     
    }
  }
 
 
  // static Future<void> handlenavigatetohome(BuildContext context) async {
 
  //   DateTime now = DateTime.now();
 
  //   if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds:2)) {
       
       
  //     currentBackPressTime = now;
  //     Fluttertoast.showToast(msg: 'Double tap to Exit');
 

  //   } else {
 
 
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Foodscreen()));
 
     
  //   }
  // }
 
  //    static Future<void> homepopp() async {
  //        Get.back();
  //   }
 
 
  //   static Future<void> homepop() async {
  //         Get.off(HomeScreenPage());
  //   }
 
 
  //   static Future<void> foodhomepop(BuildContext context) async {
  //                 Navigator.pop(context);
  //   }
 
  //   static Future<void> foodhomepage() async {
  //         Get.off(Foodscreen());
  //   }
 
 
}
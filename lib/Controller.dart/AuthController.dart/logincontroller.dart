// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:miogra_service/AuthScreen.dart/otpscreen.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Model.dart/otpmodel.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
 String usertoken = getStorage.read("Usertoken") ?? '';

 // var islogindataLoading = false.obs;
 // dynamic logindata;

//   void loginApi({dynamic mobileNo,required BuildContext context}) async {
//     try {
//       islogindataLoading(true);
//       var response = await http.post(
//         Uri.parse(API.login),
//         headers: {
//         //  "Accept": "*/*",
//           "Content-Type": "application/json",
//          // 'Authorization': 'Bearer $usertoken',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "mobileNo": mobileNo,
//         }),
//       );
//       var result = jsonDecode(response.body);
//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {
        
//       //  logindata = result;
//         print("LOGIN $result");
//  requestOtpApi(
//                                         mobileNo: mobileNo,
//                                        );
//          Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => OtpScreen(
//                                             phoneNumber: mobileNo),
//                                       ),
//                                     );
//       } else {
//        // logindata = null;
//         ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Login failed: ${result["message"]}"),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       }
//     } catch (e) {
//        // print('$error');

//     } finally {
//       islogindataLoading(false);
//     }
//   }
  var islogindataLoading = false.obs;
  dynamic logindata;

  void requestOtpApi({dynamic mobileNo}) async {
    try {
      islogindataLoading(true);
      var response = await http.post(
        Uri.parse(API.requestOtp),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $usertoken',
        },
        body: jsonEncode(<String, dynamic>{
          "mobileNo": mobileNo,
        }),
      );
      var result = jsonDecode(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        
        logindata = result;
        print("LOGIN $result");
 
                                    
      } else {
        logindata = null;
       
      }
    } catch (e) {
       // print('$error');

    } finally {
      islogindataLoading(false);
    }
  }

  var isLoading = false.obs;
  OtpModel? otpmodel;
  var successMessage = ''.obs;
  var showSmsCallMethod = false.obs;
  var isOtpFilled = false.obs;

  Future<bool> verifyotp(
  
  {required dynamic otpId, required dynamic otp,required String contactNum}) async {
    try {
      isLoading(true);
      var response = await http.post(
        Uri.parse(API.otp),
         headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $usertoken',
        },
        body: jsonEncode(<String, dynamic>{
          "otpId": otpId,
          "otp": otp,
        }),
      );
      var result = jsonDecode(response.body);
      
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        otpmodel = OtpModel.fromJson(result);
        getStorage.write("mobilenumb", contactNum); 
        
        return true;
      } else {
        successMessage.value = "OTP you entered is invalid.. Retry";
        showSmsCallMethod.value = true;
        otpmodel = null;
        return false;
      }
    } catch (error) {
    
      return false;
    } finally {
      isLoading(false);
    }
  }

 
}

// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class ActiveStatusController extends GetxController {
  Future<void> updatActiveStatus(String status) async {
    String? userId = GetStorage().read("UserId") ?? '';
    String? usertoken = getStorage.read("Usertoken") ?? '';
    try {
      var response = await http.put(Uri.parse('${API.activeStatusApi}/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $usertoken',
            'userid': userId,
            'token': usertoken,
          },
          body: jsonEncode(<String, dynamic>{"activeStatus": status}));

      if (response.statusCode >= 200 && response.statusCode <= 202) {
        
        var result = jsonDecode(response.body);
        bool active = result['data']["activeStatus"] == "online";
       await GetStorage().write('isdelactive', active);  
print('${API.activeStatusApi}/$userId');
     //   print("THE ACTIVE STATUS $active");
        print(result);

      } else {}
    } catch (e) {
      debugPrint('The Error in Active Status is $e');
    }
  }
}

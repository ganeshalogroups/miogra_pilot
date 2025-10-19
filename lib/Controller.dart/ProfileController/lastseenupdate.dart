// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';

class LastSeenUpdateController extends GetxController {
  Future<void> updateLastSeen() async {
    DateTime now = DateTime.now();
    String? userId = GetStorage().read("UserId") ?? '';
    String? usertoken = getStorage.read("Usertoken") ?? '';

    String formattedDateTime = now.toIso8601String();

    try {
      var response = await http.put(Uri.parse('${API.updateLastSeen}/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $usertoken',
            'userid': userId,
            'token': usertoken,
          },
          body: jsonEncode(<String, dynamic>{
            "lastSeen": formattedDateTime,
            "fcmToken": fcmToken
          }));

      if (response.statusCode >= 200 && response.statusCode <= 202) {
        var result = jsonDecode(response.body);
        print(result);
      } else {}
    } catch (e) {
      debugPrint('The Error is $e');
    }
  }
}

import 'dart:convert';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RedirectController extends GetxController {
  String usertoken = getStorage.read("Usertoken") ?? '';
  String userId = getStorage.read("UserId") ?? '';

  var isredirectLoading = false.obs;
  dynamic redirectLoadingDetails;

  getredirectDetails() async {
    try {
      isredirectLoading(true);
      // ignore: unnecessary_string_interpolations
      var response = await http.get(Uri.parse("${API.redirecturl}"), headers: {
        'Authorization': 'Bearer $usertoken',
        'Content-Type': 'application/json',
        'userId': userId,
      });
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        redirectLoadingDetails = result;

        debugPrint("get redirect link status ${response.body}");
      } else {
        redirectLoadingDetails = null;
      }
    } catch (e) {
      redirectLoadingDetails = null;
      return false;
    } finally {
      isredirectLoading(false);
    }
  }
}

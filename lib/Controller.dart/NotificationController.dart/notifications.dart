// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  String usertoken = getStorage.read("Usertoken") ?? '';
  String userId = getStorage.read("UserId") ?? '';

  var dataLoading = false.obs;
  var notificationsList = <dynamic>[].obs; // Initialize as an observable list

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    try {
      dataLoading.value = true;
      final response =
          await http.get(Uri.parse(API.notificationsApi), headers: {
        'Authorization': 'Bearer $usertoken',
        'Content-Type': 'application/json',
        'userId': userId,
      });

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        notificationsList.value = result['data']['data'] ?? [];
      } else {
        notificationsList.clear();
        throw Exception('Failed to load Notifications');
      }
    } catch (e) {
      // print('$error');
    } finally {
      dataLoading.value = false;
    }
  }
}

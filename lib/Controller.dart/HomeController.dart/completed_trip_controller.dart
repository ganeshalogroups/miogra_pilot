// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CompletedTripController extends GetxController {
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());

  var dataLoading = false.obs;
  var newTrips = <dynamic>[].obs; // Initialize as an observable list

  @override
  void onInit() {
    super.onInit();
    getCompletedData();
  }

Future<void> getCompletedData({startdate, endDate}) async {
    try {
      dataLoading.value = true;
      final response = await http
          .get(Uri.parse("${API.earningsApi}acceptedById=$UserId&fromDate=$startdate&toDate=$endDate&tripStatus=delivered"),
              headers: {
            'Authorization': 'Bearer $Usertoken',
            'Content-Type': 'application/json',
            'userId': UserId,
          });
      print("++++++++++++++++++++++++++++");
      print(response.body);
      if (response.statusCode == 200) {
      
      print("completed:${API.earningsApi}acceptedById=$UserId&fromDate=$startdate&toDate=$endDate&tripStatus=delivered");
      print("OKKKKKKKK");
        var result = jsonDecode(response.body);
        newTrips.value = result['data']['data'] ?? [];
        print("new trip _________________________");
        print(newTrips);
      } else {
         print("completed:${API.earningsApi}acceptedById=$UserId&fromDate=$startdate&toDate=$endDate&tripStatus=delivered");
        newTrips.clear();
        throw Exception('Failed to load New Trips');
      }
    } catch (e) {
      // print('$e');
    } finally {
      dataLoading.value = false;
    }
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class NewTripsController extends GetxController {
  String usertoken = getStorage.read("Usertoken") ?? '';
  String userId = getStorage.read("UserId") ?? '';
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());

  var dataLoading = false.obs;
  var newTrips = <dynamic>[].obs; // Initialize as an observable list

  // @override
  // void onInit() {
  //   super.onInit();

  //   getNewTrips();
  // }//
  //NEW CODE
  getNewTrips({startdate, endDate}) async {
    try {
      dataLoading.value = true;
      // Fetch the latest parentAdminId from the profile controller
      var profileData = profilScreeenController.deliveryManpProfile.isNotEmpty
          ? profilScreeenController.deliveryManpProfile.first
          : null;
      var parentAdminId = profileData != null
          ? profileData['parentAdminUserId'] ?? '6705034c34216ff9fe342fbf'
          : '6705034c34216ff9fe342fbf';

      final response = await http.get(
          Uri.parse(
              "${API.getNewTripsApi}$parentAdminId&fromDate=$startdate&toDate=$endDate"),
          headers: {
            'Authorization': 'Bearer $Usertoken',
            'Content-Type': 'application/json',
            'userId': UserId,
          });
      print("get trip id respo ${response.statusCode}");
      print(
          "new orders:${API.getNewTripsApi}$parentAdminId&fromDate=$startdate&toDate=$endDate");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        newTrips.value = result['data']['data'] ?? [];
        print("new trip ${newTrips}");
      } else {
        newTrips.clear();
        throw Exception('Failed to load New Trips');
      }
    } catch (e) {
      // print('$e');
    } finally {
      dataLoading(false);
    }
  }
  //OLD CODE
  // getNewTrips({startdate, endDate}) async {
  //   try {
  //     dataLoading.value = true;
  //     // http://ec2-15-206-69-190.ap-south-1.compute.amazonaws.com:8000/api/trip/new/list?limit=50&vendorAdminId=6705034c34216ff9fe342fbf
  //     // var profileData = profilScreeenController.deliveryManpProfile.first;
  //     // var vendorId = profileData['parentAdminUserId'] ?? '6705034c34216ff9fe342fbf';
  //     final response = await http.get(
  //         Uri.parse(
  //             "${API.getNewTripsApi}$parentAdminId&fromDate=$startdate&toDate=$endDate"),
  //         headers: {
  //           'Authorization': 'Bearer $Usertoken',
  //           'Content-Type': 'application/json',
  //           'userId': UserId,
  //         });
  //     print("get trip id respo ${response.statusCode}");

  //     print(
  //         "new orders:${API.getNewTripsApi}$parentAdminId&fromDate=$startdate&toDate=$endDate");
  //     //.print("${API.getNewTripsApi}$vendorId");
  //     if (response.statusCode == 200) {
  //       print(
  //           "new orders:${API.getNewTripsApi}$parentAdminId&fromDate=$startdate&toDate=$endDate");
  //       var result = jsonDecode(response.body);
  //       newTrips.value = result['data']['data'] ?? [];
  //       print("new trip ${newTrips}");
  //     } else {
  //       newTrips.clear();
  //       throw Exception('Failed to load New Trips');
  //     }
  //   } catch (e) {
  //     // print('$e');
  //   } finally {
  //     dataLoading(false);
  //   }
  // }

  var isdataLoading = false.obs;
  var newTripsbyid = <dynamic>[].obs;
  Future<void> getTripsbyId(String id) async {
    print("___________SS____________");
    print(" USER ID $userId           ID  $id");
    print(" USER TOKEN $usertoken        ");
    try {
      isdataLoading.value = true;
      final response =
          await http.get(Uri.parse("${API.getTripsbyidApi}$id"), headers: {
        'Authorization': 'Bearer $usertoken',
        'Content-Type': 'application/json',
        'userId': userId
      });
      print("get trip id respo ${response.statusCode}");
      print("${API.getTripsbyidApi}$id");
      if (response.statusCode == 200) {
        print("tripppp${API.getTripsbyidApi}$id");
        var result = jsonDecode(response.body);
        if (result['data'] is List) {
          newTripsbyid.value = result['data'];
          print("DATA IS LIST");
       } 
        else {
          newTripsbyid.value = [result['data']];
            print("DATA IS NOT LIST");
            print( [result['data']]);

        }
      } else {
        newTripsbyid == [];
        throw Exception('Failed to load New Trips by id');
      }
    } catch (e) {
       print('ERROR Catch $e');
    } finally {
      print("new trip ${newTripsbyid[0]["tripStatus"]}");
      isdataLoading.value = false;
    }
  }
}

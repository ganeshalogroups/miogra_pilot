// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class OrderOnProcessController extends GetxController {

  var isOrderOnProcessLoading = false.obs;
  var orderOnProcessData = Rxn<Map<String, dynamic>>();
  dynamic allProgressData;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Fetch the token and userId from storage
  //   usertoken = getStorage.read("Usertoken") ?? '';
  //   userId = getStorage.read("UserId") ?? '';

  //   if (usertoken != null && userId != null) {
  //     orderOnProcessStatus();
  //   } else {}
  // }

  Future<void> orderOnProcessStatus({startdate,enddate}) async {
    isOrderOnProcessLoading.value = true;
    print("check one orderOnProcessStatus orderOnProcessStatus orderOnProcessStatus");

    try {
      print("onr , $UserId, $Usertoken");
      final response = await http.post(
        Uri.parse(API.barStatus),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $Usertoken',
          'userid': UserId!,
        },
    
        body: jsonEncode({
          
          "userId": UserId,
          "fromDate":startdate,
          "toDate":enddate,
          "tripStatus": [
            "accepted",
            "reachedPickup",
            "pickuped",
            "reachedDelivery",
          
          ]
        }),
      );
      print("response.statusCode ${{
          
          "userId": UserId,
          "fromDate":startdate,
          "toDate":enddate,
          "tripStatus": [
            "accepted",
            "reachedPickup",
            "pickuped",
            "reachedDelivery"
          ]
        }}");
         print("USHA ${response.statusCode  } ");
        
         print("MESSAGE ${response.body  } ");
         print("MESSAGE ${API.barStatus } ");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        allProgressData = result;
        print("ongoing ***************************${API.barStatus}****");
        print(" AAAA  $allProgressData");

        if (result.containsKey('data') && result['data'] is Map) {
          var data = result['data'];

          if (data.containsKey('data') &&
              data['data'] is List &&
              data['data'].isNotEmpty) {
            orderOnProcessData.value =
                data['data'][0]; // Update Rxn<Map<String, dynamic>> value
          } else {
            orderOnProcessData.value = null;
          }
        } else {
          orderOnProcessData.value = null;
        }
      } else {
      //   allProgressData = null;
         print("GANAPATHY");
        orderOnProcessData.value = null;
      }
    } catch (e) {
      orderOnProcessData.value = null; // Ensure value is set to null on error
    } finally {
      isOrderOnProcessLoading.value = false;
    }
  }
}

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ProfilScreeenController extends GetxController {
  var dataLoading = false.obs;
var isactive =false.obs;
  var deliveryManpProfile = <dynamic>[].obs; // Keep as an observable list

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      dataLoading.value = true;
      final response =
          await http.get(Uri.parse("${API.profileGetApi}/$UserId"), headers: {
        'Authorization': 'Bearer $Usertoken',
        'Content-Type': 'application/json',
        'userId': UserId,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);



        print("APIIIII  ${API.profileGetApi}/$UserId");

        if (responseBody['data'] != null) {
          print(responseBody['data']["activeStatus"]);
          deliveryManpProfile.value = [responseBody['data']];
          parentAdminId = responseBody['data']["parentAdminUserId"];
       
          switchValue =
              responseBody['data']["activeStatus"] == "offline" ? false : true;
        isactive.value =   responseBody['data']["activeStatus"] == "online" ? true : false;
bool active = responseBody['data']["activeStatus"] == "online";

            await GetStorage().write('isdelactive',active);  
           //  isdelactive =  responseBody['data']["activeStatus"] ;
        print("HELLO GANESH $isdelactive  ");
          username = responseBody['data']["name"].toString();
        } else {}
      } else {}
    } catch (e) {
      // print('$e');
    } finally {
      dataLoading.value = false;
    }
  }

  void logout() {
    dataLoading.value = false;
    deliveryManpProfile.clear();
  }
}

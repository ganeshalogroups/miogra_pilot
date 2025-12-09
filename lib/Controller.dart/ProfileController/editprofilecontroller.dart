// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profileimageupdate.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class EditProfileController extends GetxController {
  final box = GetStorage();
  ProfileImageUploader profileImageUploader = Get.put(ProfileImageUploader());
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());
  final delPartName = ''.obs;
  final emailId = ''.obs;
  final mobNumb = ''.obs;
  final street1 = ''.obs;
  final street2 = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final pincode = ''.obs;
  final delarea = ''.obs;
  final nearBy = ''.obs;
  final pickedImage = Rx<File?>(null);
  final savedImage = ''.obs;

  String? imageUpdateUrl;

  void pickImages(File? image) {
    pickedImage.value = image;
    if (image != null) {
      profileImageUploader.uploadProfileImage(file: image);
      savedImage.value = image.path;
      imageUpdateUrl = profileImageUploader.imageURL.value;
      box.write('imageUpdateUrl', image.path);
      savedImage.value = box.read('imageUpdateUrl') ?? '';
    } else {
      profileImageUploader.uploadProfileImage(
          file: profileImageUploader.selectedImage.value);
      savedImage.value = profileImageUploader.selectedImage.value.path;
      imageUpdateUrl = profileImageUploader.imageURL.value;
      box.write(
          'imageUpdateUrl', profileImageUploader.selectedImage.value.path);
      savedImage.value = box.read('imageUpdateUrl') ?? '';
    }
  }

  void updateImageUrl(String url) {
    savedImage.value = url;
  }

  Future<void> updateProfileScreen(
      String name, String image, Map<String, dynamic> address) async {
    String? userId = box.read("UserId") ?? '';
    String? usertoken = box.read("Usertoken") ?? '';

    try {
      var response = await http.put(
          Uri.parse('${API.profileUpdateApi}/$UserId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $usertoken',
            'userid': userId,
            'token': usertoken,
          },
          body: jsonEncode(<String, dynamic>{
            "name": name,
            "address": address,
            "imgUrl": image
          }));

      if (response.statusCode >= 200 && response.statusCode <= 202) {
        print("API WORKING");
        var result = jsonDecode(response.body);
        profilScreeenController.getProfile();
        Get.offAll(
          () => DeliveryBottomNavigation(
            showBottomSheet: false,
            initialIndex: 2,
          ),
        );
      } else {
print("API NOT WORKING");


      }
    } catch (e) {
      debugPrint('The Error in Update Profile is $e');
    }
  }

  Future<void> updateProfileforTravel(
     ) async {
    String? userId = box.read("UserId") ?? '';
    String? usertoken = box.read("Usertoken") ?? '';

    try {
      var response = await http.put(
          Uri.parse('${API.profileUpdateApi}/$UserId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $usertoken',
            'userid': userId,
            'token': usertoken,
          },
          body: jsonEncode(<String, dynamic>{
          "onTarvel":false
          }));

      
    } catch (e) {
      debugPrint('The Error in Update Profile is $e');
    }
  }

  void clearData() {
    delPartName.value = '';
    emailId.value = '';
    mobNumb.value = '';
    street1.value = '';
    street2.value = '';
    city.value = '';
    state.value = '';
    pincode.value = '';
    delarea.value = '';
    nearBy.value = '';
    pickedImage.value = null;
    savedImage.value = '';
    profileImageUploader.imageURL.value = '';
  }
}

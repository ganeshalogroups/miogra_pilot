// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:mime/mime.dart';

class ProfileImageUploader extends GetxController {
  var isFileUploading = false.obs;
  var imageURL = "".obs;
  var selectedImage = File("").obs;

  String usertoken = getStorage.read("Usertoken") ?? '';

  Future<void> uploadProfileImage({File? file}) async {
    try {
      isFileUploading(true);
      String fileName = file!.path.split('/').last;

      String? mimeType = lookupMimeType(file.path) ?? "image/png";

      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: dio.DioMediaType.parse(mimeType),
        ),
      });

      var response = await dio.Dio().post(
        API.bannerUpload,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $usertoken',
            'userId': UserId!,
          },
        ),
      );

      var result = response.data;
      if (response.statusCode == 200) {
        imageURL(result["data"]["imgUrl"]);
      } else {
        Get.snackbar(
          "Profile Image upload Failed",
          "Error: ${result["message"]}",
        );
      }
    } catch (error) {
      Get.snackbar("Upload Error", "An error occurred: $error");
    } finally {
      isFileUploading(false);
    }
  }
}

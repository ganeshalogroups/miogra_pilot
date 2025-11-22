// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart'; 

class ImageUploader {
 
  var isFileUploading = false.obs;
  var imageAFURL = "".obs;
  String usertoken = getStorage.read("Usertoken") ?? '';
  Future uploadAdharFrontImage({File? file}) async {
   
    try {
      isFileUploading(true);
      String fileName = file!.path.split('/').last;
       String? mimeType = lookupMimeType(file.path); 
      if (mimeType == null || mimeType == "application/octet-stream") {
        mimeType = "image/png"; 
      }



      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          file.path, filename: fileName,
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
          },
        ),
      );

      var result = response.data;
     
      if (response.statusCode == 200) {
       imageAFURL (response.data["data"]["imgUrl"]);
       print("Image uploaded successfully");

      } else {
        Get.snackbar(
          "File Upload Failed",
          "Aadhar Front......: ${result["data"]["imgUrl"]}",
        );
         print("Image uploaded failed");
      }
    } catch (error) {
       // print('$error');
        print("Image uploaded failed catch error $error");

    } finally {
      isFileUploading(false);
    }
  }

  var isABFileUploading = false.obs;
  var imageABURL = "".obs;

  Future uploadAdharBackImage({File? file}) async {
    try {
      isABFileUploading(true);
      String fileName = file!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await dio.Dio().post(
        API.bannerUpload,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $usertoken',
          },
        ),
      );

      var result = response.data;
      if (response.statusCode == 200) {
        imageABURL(result["data"]["imgUrl"]);
      } else {
        Get.snackbar(
          "File Upload Failed",
          "Aadhar Back: ${result["data"]["imgUrl"]}",
        );
      }
    } catch (error) {
   // print('$error');
    } finally {
      isABFileUploading(false);
    }
  }

  var isLFFileUploading = false.obs;
  var imageLFURL = "".obs;

  Future uploadLicenseFrontImage({File? file}) async {
  
print("///////////////////////////////////////////////////////////////");
    try {
      isLFFileUploading(true);
      String fileName = file!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });
      print("////////////////////////////////////////////${usertoken}///////////////////");
      var response = await dio.Dio().post(
        API.bannerUpload,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
             'userId': UserId,
            'Authorization': 'Bearer $usertoken',
          },
        ),
      );

      var result = response.data;
      if (response.statusCode == 200) {
      print("imagee:${result["data"]["imgUrl"]}");
        imageLFURL(result["data"]["imgUrl"]);
      } else {
        Get.snackbar(
          "File Upload Failed",
          "License Front......: ${result["data"]["imgUrl"]}",
        );
      }
    } catch (error) {
    print("image error: ${error}");
       // print('$error');

    } finally {
      isLFFileUploading(false);
    }
  }

  var isFileLBUploading = false.obs;
  var imageLBURL = "".obs;

  Future uploadLicenseBackImage({File? file}) async {
    try {
      isFileLBUploading(true);
      String fileName = file!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await dio.Dio().post(
        API.bannerUpload,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $usertoken',
          },
        ),
      );

      var result = response.data;
      if (response.statusCode == 200) {
        imageLBURL(result["data"]["imgUrl"]);
      } else {
        Get.snackbar(
          "File Upload Failed",
          "License Back......: ${result["data"]["imgUrl"]}",
        );
      }
    } catch (error) {
       // print('$error');

    } finally {
      isFileLBUploading(false);
    }
  }

  var isFileRCUploading = false.obs;
  var imageRCURL = "".obs;

  Future uploadRCImage({File? file}) async {
    try {
      isFileRCUploading(true);
      String fileName = file!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await dio.Dio().post(
        API.bannerUpload,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $usertoken',
          },
        ),
      );

      var result = response.data;
      if (response.statusCode == 200) {
        imageRCURL(result["data"]["imgUrl"]);
      } else {
        Get.snackbar(
          "File Upload Failed",
          "Rc......: ${result["data"]["imgUrl"]}",
        );
      }
    } catch (error) {
       // print('$error');

    } finally {
      isFileRCUploading(false);
    }
  }

  var isFileIUploading = false.obs;
  var imageLURL = "".obs;

  Future uploadInsuranceImage({File? file}) async {
    try {
      isFileIUploading(true);
      String fileName = file!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await dio.Dio().post(
        API.bannerUpload,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $usertoken',
          },
        ),
      );

      var result = response.data;
      if (response.statusCode == 200) {
        imageLURL(result["data"]["imgUrl"]);
      } else {
        Get.snackbar(
          "File Upload Failed",
          "Insurance......: ${result["data"]["imgUrl"]}",
        );
      }
    } catch (error) {
       // print('$error');

    } finally {
      isFileIUploading(false);
    }
  }
}

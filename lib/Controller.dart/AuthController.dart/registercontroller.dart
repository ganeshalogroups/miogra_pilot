// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/fileuploadcontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  final RegionController regionController = Get.find<RegionController>();
  ImageUploader imageUploader = Get.put(ImageUploader());
  String usertoken = getStorage.read("Usertoken") ?? '';

  final stepUserName = ''.obs;
  final stepMobileNum = ''.obs;
  final stepEmergMobileNum = ''.obs;
  final steptEmail = ''.obs;
  final steptPincode = ''.obs;
  final vehicleNumb = ''.obs;
  final bankName = ''.obs;
  final acctype = ''.obs;
  final accNumb = ''.obs;
  final reAccNumb = ''.obs;
  final ifscCode = ''.obs;
  final jobType = 'Part-Time'.obs;
  final vehicleType = 'E-bike'.obs;
  final regionData = ''.obs;
  final deliveryBag = false.obs;
  final tShirt = false.obs;
  final aadharFrontUrl = ''.obs;
  final aadharBackUrl = ''.obs;
  final licenseFrontUrl = ''.obs;
  final licenseBackUrl = ''.obs;
  final rcUrl = ''.obs;
  final insuranceUrl = ''.obs;
  var parentadminuserid = ''.obs;

  void clearData() {
    stepUserName.value = '';
    stepMobileNum.value = '';
    stepEmergMobileNum.value = '';
    steptEmail.value = '';
  }

  void regionGet(String region, String regionUserId) {
    regionData.value = region;
    parentadminuserid.value = regionUserId;
  }

  void restNameGet(String newValue) {
    stepUserName.value = newValue;
  }

  void restMobileNumGet(String newValue) {
    stepMobileNum.value = newValue;
  }

  void restEmergMobile(String newValue) {
    stepEmergMobileNum.value = newValue;
  }

  void restEMailGet(String newValue) {
    steptEmail.value = newValue;
  }

  void restPincodeGet(String newValue) {
    steptPincode.value = newValue;
  }

  void vehicleNumbGet(String newValue) {
    vehicleNumb.value = newValue;
  }

  void bankNameGet(String newValue) {
    bankName.value = newValue;
  }

  void acctypeGet(String newValue) {
    acctype.value = newValue;
  }

  void accNumbGet(String newValue) {
    accNumb.value = newValue;
  }

  void reAccNumbGet(String newValue) {
    reAccNumb.value = newValue;
  }

  void ifscCodeGet(String newValue) {
    ifscCode.value = newValue;
  }

  void jobTypeGet(String newValue) {
    jobType.value = newValue;
  }

  void vehicleTypeGet(String newValue) {
    vehicleType.value = newValue;
  }

  void updateDeliveryBag(bool value) {
    deliveryBag.value = value;
  }

  void updateTShirt(bool value) {
    tShirt.value = value;
  }

  var isPersonalInfoCompleted = false.obs;
  var isVehicleInfoCompleted = false.obs;
  var isBankDetailsCompleted = false.obs;

  var phoneValidationError = ''.obs;

  void updatePhoneValidationError(String error) {
    phoneValidationError.value = error;
  }

  void updatePersonalInfoStatus(bool completed) {
    isPersonalInfoCompleted.value = completed;
  }

  void updateVehicleInfoStatus(bool completed) {
    isVehicleInfoCompleted.value = completed;
  }

  void updateBankDetailsStatus(bool completed) {
    isBankDetailsCompleted.value = completed;
  }

  void updateAadharFrontUrl(String url) {
    aadharFrontUrl.value = url;
  }

  void updateAadharBackUrl(String url) {
    aadharBackUrl.value = url;
  }

  void updateLicenseFrontUrl(String url) {
    licenseFrontUrl.value = url;
  }

  void updateLicenseBackUrl(String url) {
    licenseBackUrl.value = url;
  }

  void updateRcUrl(String url) {
    rcUrl.value = url;
  }

  void updateInsuranceUrl(String url) {
    insuranceUrl.value = url;
  }

  var isDataLoading = false.obs;
  dynamic regDetails;

  var personalInfo = RegisterPersonalInfo(
    name: '',
    countryCode: '',
    phoneNumber: '',
    emergencyContact: '',
    email: '',
    pincode: '',
    jobType: '',
    aadharFront: '',
    aadharBack: '',
  ).obs;

  var vehicleInfo = VehicleInfo(
    vehicleType: '',
    vehicleNumber: '',
    insurance: '',
    licenseFront: '',
    licenseBack: '',
    rc: '',
  ).obs;

  var bankDetails = BankDetailsInfo(
    accountNumber: '',
    ifscCode: '',
    bankName: '',
    accountType: '',
  ).obs;

  var workSetupInfo = WorkSetupInfo(
    selectedLocation: '',
    deliveryBag: false,
    dress: false,
  ).obs;

  dynamic registerdata;

  void registerApi({
    required List<String> pinCode,
    required String selectedLocation,
    required bool deliveryBag,
    required bool dress,
  }) async {
    try {
      isDataLoading(true);

      // Validate completion status
      if (!isPersonalInfoCompleted.value ||
          !isVehicleInfoCompleted.value ||
          !isBankDetailsCompleted.value ||
          selectedLocation.isEmpty) {
        Get.snackbar(
          'Incomplete Information',
          'Please complete all required fields.',
          backgroundColor: Customcolors.decorationBlueOrange,
          colorText: Customcolors.decorationBlack,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Debugging: Print the data being sent

      String postalCodeString = pinCode.join(', ');
      var response = await http.post(
        Uri.parse(API.register),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "Authorization": "Bearer $usertoken",
        },
        body: jsonEncode(<String, dynamic>{
          "name": personalInfo.value.name,
          "email": personalInfo.value.email,
          "mobileNo": personalInfo.value.phoneNumber,
          "role": "deliveryman",
          "jobType": personalInfo.value.jobType,
          "aditionalContactNumber": personalInfo.value.emergencyContact,
          "parentAdminUserId": parentadminuserid.value,
          "lastSeen": null,
          "BankDetails": {
            "bankName": bankDetails.value.bankName,
            "acType": bankDetails.value.accountType,
            "accountNumber": bankDetails.value.accountNumber,
            "ifscCode": bankDetails.value.ifscCode,
            "branchName": "kottar",
          },
          "address": {
            "houseNo": null,
            "district": null,
            "companyName": null,
            "fullAddress": null,
            "street": null,
            "city": null,
            "state": null,
            "country": null,
            "postalCode": int.parse(steptPincode.toString()),
            "landMark": null,
            "contactPerson": null,
            "contactPersonNumber": null,
            "addressType": null,
            "latitude": null,
            "longitude": null,
            "region": selectedLocation
          },
          "adminUserKYC": {
            "DOB": null,
            "idProofType": null,
            "idProofNumber": null,
            "idProofFrontPicUrl": imageUploader.imageAFURL.value,
            "idProofBackPicUrl": imageUploader.imageABURL.value,
            "licenseProofFrontPicUrl": imageUploader.imageLFURL.value,
            "licenseProofBackPicUrl": imageUploader.imageLBURL.value,
            "rcPicFrontUrl": imageUploader.imageRCURL.value,
            "rcPicBackUrl": imageUploader.imageLURL.value,
          },
          "vehicleDetails": {
            "vehicleName": null,
            "vehicleType": vehicleInfo.value.vehicleType,
            "vehicleNumber": vehicleInfo.value.vehicleNumber,
            "isDeliveryBag": deliveryBag,
            "isDress": dress,
          }
        }),
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        var result = jsonDecode(response.body);
        registerdata = result;

        var message = result['message'] ?? 'Registration successful';
        Get.snackbar(
          'Registration Successful',
          message,
          backgroundColor: Customcolors.decorationBlueOrange,
          colorText: Customcolors.decorationBlack,
          snackPosition: SnackPosition.BOTTOM,
        );

        getStorage.write('useremail', personalInfo.value.email);
        getStorage.write('mobilenumb', personalInfo.value.phoneNumber);
        getStorage.write('username', personalInfo.value.name);

        // Storing data or navigating if needed
        // Assuming registration is successful and no data is returned
        Get.offAll(() => DeliveryBottomNavigation(
              showBottomSheet: false,
              pendingrequest: true,
            ));
      } else {
        // Handle error response
        registerdata = null;

        Get.snackbar(
          'Registration Failed',
          'Please try again later.',
          backgroundColor: Customcolors.decorationBlueOrange,
          colorText: Customcolors.decorationBlack,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Registration Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Customcolors.decorationBlueOrange,
        colorText: Customcolors.decorationBlack,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDataLoading(false);
    }
  }
}

class RegisterPersonalInfo {
  String name;
  String countryCode;
  String phoneNumber;
  String emergencyContact;
  String email;
  String jobType;
  String aadharFront;
  String aadharBack;
  String pincode;

  RegisterPersonalInfo({
    required this.name,
    required this.countryCode,
    required this.phoneNumber,
    required this.emergencyContact,
    required this.email,
    required this.jobType,
    required this.aadharFront,
    required this.aadharBack,
    required this.pincode,
  });
}

class VehicleInfo {
  String vehicleType;
  String vehicleNumber;
  String insurance;
  String licenseFront;
  String licenseBack;
  String rc;

  VehicleInfo({
    required this.vehicleType,
    required this.vehicleNumber,
    required this.insurance,
    required this.licenseFront,
    required this.licenseBack,
    required this.rc,
  });
}

class BankDetailsInfo {
  String accountNumber;
  String ifscCode;
  String bankName;
  String accountType;

  BankDetailsInfo({
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.accountType,
  });
}

class WorkSetupInfo {
  String selectedLocation;
  bool deliveryBag;
  bool dress;

  WorkSetupInfo({
    required this.selectedLocation,
    required this.deliveryBag,
    required this.dress,
  });
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:async';
import 'package:miogra_service/Controller.dart/AuthController.dart/fileuploadcontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/registercontroller.dart';
import 'package:flutter/material.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_identityproof.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textformfield.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';

class VehicleInformation extends StatefulWidget {
  final Function(int) onStepComplete;
  final TabController? tabController;
  final String? initialVehicleNumber;
  final String? initialVehicleType;
  final String? initialLicenseFrontUploaded;
  final String? initialLicenseBackUploaded;
  final String? initialRcUploaded;
  final String? initialInsuranceUploaded;

  const VehicleInformation({
    super.key,
    required this.onStepComplete,
    this.tabController,
    this.initialVehicleNumber,
    this.initialVehicleType,
    this.initialLicenseFrontUploaded,
    this.initialLicenseBackUploaded,
    this.initialRcUploaded,
    this.initialInsuranceUploaded,
  });

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

File? _licenseFront;
File? _licenseBack;
File? _rc;
File? _insurance;
String? lFUrl;
String? lbUrl;
String? rUrl;
String? iUrl;
String? licenseF;
String? licenseB;
String? iRc;
String? iInsurance;
bool _isFormsValid = false;

class _VehicleInformationState extends State<VehicleInformation> {
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  String? _vehicleType;
  String? _validationMessage;

  final vehicleformkey = GlobalKey<FormState>();
  RegisterController vehicleRegisterController = Get.put(RegisterController());
  ImageUploader imageUploader = Get.put(ImageUploader());
  bool isLoading = false;
  bool _isUploading = false;

  void saveVehicleInfo() {
    vehicleRegisterController.vehicleInfo.update((info) {
      info?.vehicleType = _vehicleType!;
      info?.vehicleNumber = _vehicleNumberController.text;
      print('vehicle type $_vehicleType');

      if (_licenseFront != null) {
        vehicleRegisterController.updateLicenseFrontUrl(_licenseFront!.path);
      }
      if (_licenseBack != null) {
        vehicleRegisterController.updateLicenseBackUrl(_licenseBack!.path);
      }
      if (_rc != null) {
        vehicleRegisterController.updateRcUrl(_rc!.path);
      }
      if (_insurance != null) {
        vehicleRegisterController.updateInsuranceUrl(_insurance!.path);
      }
    });
    vehicleRegisterController.updateVehicleInfoStatus(_isFormsValid);
  }

  @override
  void initState() {
    super.initState();
    _vehicleNumberController.text = vehicleRegisterController.vehicleNumb.value;
    _vehicleType = vehicleRegisterController.vehicleType.value;
    _vehicleType = widget.initialVehicleType ??
        vehicleRegisterController.vehicleType.value;
    licenseF = widget.initialLicenseFrontUploaded ??
        vehicleRegisterController.licenseFrontUrl.value;
    licenseB = widget.initialLicenseBackUploaded ??
        vehicleRegisterController.licenseBackUrl.value;
    iRc = widget.initialRcUploaded ?? vehicleRegisterController.rcUrl.value;
    iInsurance = widget.initialInsuranceUploaded ??
        vehicleRegisterController.insuranceUrl.value;

    _validateForm();
  }

  void _validateForm() async {
    if (mounted) {
      setState(() {
      String? vehNumber= validateVehicleNumber(
      _vehicleNumberController.text);
        _isFormsValid =
            vehNumber==null &&
                _vehicleType != null &&
                _licenseFront != null &&
                _licenseBack != null; 
               // _rc != null &&
              //  _insurance != null;
      });
      vehicleRegisterController.updateVehicleInfoStatus(_isFormsValid);
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: vehicleformkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Vehicle Information',
                style: CustomTextStyle.mediumBoldText,
              ),
              Column(
                children: [
                  CustomTextFormField(
                    controller: _vehicleNumberController,
                    inputFormatters: [
                      // Forces all input to uppercase
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                        ),
                      ),
                    ],
                    validator: (value) {
                      return validateVehicleNumber(
                          value); // This will be used when the form is submitted
                    },
                    onChanged: (text) {
                      _validationMessage = validateVehicleNumber(text);
                      vehicleRegisterController.vehicleNumbGet(text);
                      _validateForm();
                    },
                    labelText: null,
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Vehicle Number',
                            style: CustomTextStyle.labelText,
                          ),
                          TextSpan(
                            text: ' ⁕',
                            style: CustomTextStyle.starText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_validationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _validationMessage!,
                        style: TextStyle(
                            color: Color.fromARGB(255, 158, 15, 5),
                            fontSize: 10),
                      ),
                    ),
                ],
              ),
              CustomSizedBox(height: 10),
              CustomText(
                text: 'Vehicle Type',
                style: CustomTextStyle.normalBoldText,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Obx(() => Radio<String>(
                              value: 'E-bike',
                              groupValue:
                                  vehicleRegisterController.vehicleType.value,
                              activeColor: 
 Color(0xFF623089),
                              onChanged: (String? value) {
                                vehicleRegisterController
                                    .vehicleTypeGet(value!);
                              _vehicleType=value;

                                _validateForm();
                              },
                            )),
                        CustomText(
                          text: 'E-bike',
                          style: CustomTextStyle.normalText,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Obx(() => Radio<String>(
                              value: 'Bike',
                              groupValue:
                                  vehicleRegisterController.vehicleType.value,
                              activeColor: 
 Color(0xFF623089),
                              onChanged: (String? value) {
                                vehicleRegisterController
                                    .vehicleTypeGet(value!);
                                    _vehicleType=value;
                                _validateForm();
                              },
                            )),
                        CustomText(
                          text: 'Bike',
                          style: CustomTextStyle.normalText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomSizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Documents',
                    style: CustomTextStyle.normalBoldText,
                  ),
                  CustomSizedBox(height: 15),
                  CustomText(
                    text: 'License',
                    style: CustomTextStyle.identityGreyText,
                  ),
                  CustomSizedBox(height: 15),
                  IdentityProof(
                    onFileChosen: (File? image) async {
                      if (image != null) {
                        setState(() {
                          _isUploading = true;
                        });

                        _licenseFront = image;
                        final url = await imageUploader.uploadLicenseFrontImage(
                            file: image);

                        if (url != null) {
                          vehicleRegisterController.updateLicenseFrontUrl(url);
                          setState(() {
                            _licenseFront = image;
                            _isUploading = false;
                          });
                        } else {
                          setState(() {
                            _isUploading = false;
                          });
                          // Handle upload failure
                        }
                        _validateForm();
                      }
                    },
                    label: 'License Front',
                    initialFile:
                        File(vehicleRegisterController.licenseFrontUrl.value),
                  ),
                  CustomSizedBox(height: 10),
                  IdentityProof(
                    onFileChosen: (File? image) async {
                      if (image != null) {
                        setState(() {
                          _isUploading = true;
                        });

                        _licenseBack = image;
                        final url = await imageUploader.uploadLicenseBackImage(
                            file: image);

                        if (url != null) {
                          vehicleRegisterController.updateLicenseBackUrl(url);
                          setState(() {
                            _licenseBack = image;
                            _isUploading = false;
                          });
                        } else {
                          setState(() {
                            _isUploading = false;
                          });
                          // Handle upload failure
                        }
                        _validateForm();
                      }
                    },
                    label: 'License Back',
                    initialFile:
                        File(vehicleRegisterController.licenseBackUrl.value),
                  ),
                  CustomSizedBox(height: 10),
                  // CustomText(
                  //   text: 'RC',
                  //   style: CustomTextStyle.identityGreyText,
                  // ),
                  // CustomSizedBox(height: 10),
                  // IdentityProof(
                  //   onFileChosen: (File? image) async {
                  //     if (image != null) {
                  //       setState(() {
                  //         _isUploading = true;
                  //       });

                  //       _rc = image;
                  //       final url =
                  //           await imageUploader.uploadRCImage(file: image);

                  //       if (url != null) {
                  //         vehicleRegisterController.updateRcUrl(url);
                  //         setState(() {
                  //           _rc = image;
                  //           _isUploading = false;
                  //         });
                  //       } else {
                  //         setState(() {
                  //           _isUploading = false;
                  //         });
                  //         // Handle upload failure
                  //       }
                  //       _validateForm();
                  //     }
                  //   },
                  //   label: 'RC Front',
                  //   initialFile: File(vehicleRegisterController.rcUrl.value),
                  // ),
                  // CustomSizedBox(height: 10),
                  // IdentityProof(
                  //   onFileChosen: (File? image) async {
                  //     if (image != null) {
                  //       setState(() {
                  //         _isUploading = true;
                  //       });

                  //       _insurance = image;
                  //       final url = await imageUploader.uploadInsuranceImage(
                  //           file: image);

                  //       if (url != null) {
                  //         vehicleRegisterController.updateInsuranceUrl(url);
                  //         setState(() {
                  //           _insurance = image;
                  //           _isUploading = false;
                  //         });
                  //       } else {
                  //         setState(() {
                  //           _isUploading = false;
                  //         });
                  //         // Handle upload failure
                  //       }
                   //      _validateForm();
                  //     }
                  //   },
                  //   label: 'RC Back',
                  //   initialFile:
                  //       File(vehicleRegisterController.insuranceUrl.value),
                  // ),
                ],
              ),
              CustomSizedBox(height: 60),
              _isFormsValid && !_isUploading
                  ? CustomButton(
                    height: 50,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () {
                        if (vehicleformkey.currentState!.validate()) {
                          widget.onStepComplete(1); // Mark step as complete
                          widget.tabController?.animateTo(
                              2); // Switch to Vehicle Information tab
                          saveVehicleInfo();
                        }
                      },
                      child: CustomText(
                        text: 'Continue',
                        style: CustomTextStyle.buttonText,
                      ),
                    )
                  : CustomdisabledButton(
                    height: 50,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () {},
                      child: _isUploading
                          ? CircularProgressIndicator(
                              color:
 Color(0xFF623089)) // Show loading spinner during upload
                          : CustomText(
                              text: 'Continue',
                              style: CustomTextStyle.greyButtonText,
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a vehicle number';
    }
    final regex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid vehicle number';
    }
    return null;
  }
}
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/fileuploadcontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/registercontroller.dart';
import 'package:miogra_service/Validators.dart/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_identityproof.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textformfield.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'dart:io';

import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

  

class PersonalInformation extends StatefulWidget {
  final String? loginMobileNumb;
  final Function(int) onStepComplete;
  final TabController? tabController;
  final String? initialName; // Example: Pass initial values if available
  final String? initialCountryCode;
  final String? initialPhoneNumber;
  final String? initialEmergencyContact;
  final String? initialEmail;
  final String? initialJobType;
  final String? initialAadharFront;
  final String? initialAadharBack;

  const PersonalInformation({
    Key? key,
    required this.onStepComplete,
    this.tabController,
    this.initialName,
    this.initialCountryCode,
    this.initialPhoneNumber,
    this.initialEmergencyContact,
    this.initialEmail,
    this.initialJobType,
    this.initialAadharFront,
    this.initialAadharBack,
    this.loginMobileNumb,
  }) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

bool isLoading = false;
String? _validationMessage;
String? _validationMessageEC;
String? _jobType;
bool _isFormValid = false;
File? _aadharFront;
File? _aadharBack;
String? aadharF;
String? aadharB;
bool _isUploading = false;

class _PersonalInformationState extends State<PersonalInformation> {
  RegisterController personalregisterController = Get.put(RegisterController());
  ImageUploader imageUploader = Get.put(ImageUploader());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  // final FlutterContactPicker _contactPicker =
  //     FlutterContactPicker();
      final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  final TextEditingController contactperson = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  late TextEditingController _countryController;
  final _formkey = GlobalKey<FormState>();

  void savePersonalInfo() {
    personalregisterController.personalInfo.update((info) {
      info?.name = _nameController.text;
      info?.countryCode = _countryController.text;
      info?.phoneNumber = _phoneController.text;
      info?.emergencyContact = _textFieldController.text;
      info?.email = _emailController.text;
      info?.jobType = _jobType!;
      info?.pincode = _pincodeController.text;
      // info?.aadharFront=aadharF!;
      // info?.aadharBack=aadharB!;
      if (_aadharFront != null) {
        personalregisterController.updateAadharFrontUrl(_aadharFront!.path);
      }
      if (_aadharBack != null) {
        personalregisterController.updateAadharBackUrl(_aadharBack!.path);
      }
    });
    personalregisterController.updatePersonalInfoStatus(_isFormValid);
  }

  @override
  void initState() {
    super.initState();

    _countryController =
        TextEditingController(text: widget.initialCountryCode ?? "+91");

    _phoneController.text = widget.loginMobileNumb ??
        personalregisterController.stepMobileNum.value;
    _nameController.text = personalregisterController.stepUserName.value;
    _textFieldController.text =
        personalregisterController.stepEmergMobileNum.value;
    _emailController.text = personalregisterController.steptEmail.value;
    _pincodeController.text = personalregisterController.steptPincode.value;
    _jobType = personalregisterController.jobType.value;
    _jobType =
        widget.initialJobType ?? personalregisterController.jobType.value;
    aadharF = personalregisterController.aadharFrontUrl.value;
    // aadharF = widget.initialAadharFront ??
    //     personalregisterController.aadharFrontUrl.value;
    aadharB = personalregisterController.aadharBackUrl.value;
    // aadharB = widget.initialAadharFront ??
    //     personalregisterController.aadharBackUrl.value;

    _countryController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _textFieldController.addListener(_validateForm);
    _emailController.addListener(_validateForm);

    _validateForm(); // Validate form initially based on provided initial values
  }

  void _validateForm() {
    if (mounted) {
      setState(() {
        _isFormValid = _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _textFieldController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _pincodeController.text.isNotEmpty &&
            personalregisterController.jobType.value.isNotEmpty &&
            _aadharFront != null &&
            _aadharBack != null;
      });

      personalregisterController.updatePersonalInfoStatus(_isFormValid);
    }
  }

  @override
  void dispose() {
    _countryController.removeListener(_validateForm);
    _phoneController.removeListener(_validateForm);
    _textFieldController.removeListener(_validateForm);
    _emailController.removeListener(_validateForm);

    _countryController.dispose();
    _phoneController.dispose();
    _textFieldController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        widget.tabController?.animateTo(0);
        return;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: 'Personal Information',
                      style: CustomTextStyle.mediumBoldText),
                  CustomTextFormField(
                    labelText: null,
                    controller: _nameController,
                    validator: validateName,
                    onChanged: (text) {
                      personalregisterController.restNameGet(text);
                    },
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Name',
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
                  CustomSizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContainer(
                        height: MediaQuery.of(context).size.height / 14,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomContainer(
                              height: 20,
                              width: 20,
                              child: Image.asset('assets/images/India.png'),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 35,
                              child: TextFormField(
                                controller: _countryController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            Container(
                              height: 30, // Increased height of the line
                              width: 1.5, // Reduced width of the line
                              color: Colors.grey.shade400, // Line color
                            ), 
                            SizedBox(width: 13),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: TextFormField(
                                readOnly: true,
                                controller: _phoneController,
                                maxLength: 10,
                                buildCounter: (BuildContext context,
                                    {int? currentLength,
                                    bool? isFocused,
                                    int? maxLength}) {
                                  return null; // This removes the counter text
                                },
                                onChanged: (text) {
                                  setState(() {
                                    _validationMessage = validatePhone(text);
                                    personalregisterController
                                        .restMobileNumGet(text);
                                  });
                                  _validateForm(); // Call the form validation function to update the form state
                                },
                                validator: (value) {
                                  return validatePhone(
                                      value); // This will be used when the form is submitted
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: null,
                                  label: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Mobile Number',
                                          style:
                                              CustomTextStyle.mobilelabelText,
                                        ),
                                        TextSpan(
                                          text: ' ⁕',
                                          style: CustomTextStyle.starText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                  CustomSizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        labelText: null,
                        maxLength: 13,
                        onChanged: (text) {
                          personalregisterController.restEmergMobile(text);
                          setState(() {
                            _validationMessageEC = validatePhone(text);
                          });
                        },
                        controller: _textFieldController,
                        validator: (value) {
                          return validatePhone(value);
                        },
                        keyboardType: TextInputType.number,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.account_box_outlined,
                          ),
                          color: Colors.grey.shade400,
                          onPressed: () async {
                            // native_contact_picker.Contact? contact =
                            //     await _contactPicker.selectContact();
                      Contact? contact =
                                await _contactPicker.selectContact();
                            setState(() {
                              _textFieldController.text = contact
                                      ?.phoneNumbers!.first
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", "")
                                      .replaceAll("+91", "")
                                      .replaceAll(" ", "") ??
                                  '';

                              // Set the validation message after updating the text field
                              _validationMessageEC =
                                  validatePhone(_textFieldController.text);
                            });
                            personalregisterController
                                .restEmergMobile(_textFieldController.text);
                            _validateForm();
                          },
                        ),
                        label: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Emergency Contact',
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
                      if (_validationMessageEC != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _validationMessageEC!,
                            style: TextStyle(
                              color: Color.fromARGB(255, 158, 15, 5),
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  CustomSizedBox(height: 20),
                  CustomTextFormField(
                    labelText: null,
                    controller: _emailController,
                    validator: validateEmail,
                    onChanged: (text) {
                      personalregisterController.restEMailGet(text);
                    },
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'E-Mail',
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
                  CustomSizedBox(height: 20),
                  CustomTextFormField(
                    labelText: null,
                    controller: _pincodeController,
                    validator: validatePincode,
                    onChanged: (text) {
                      personalregisterController.restPincodeGet(text);
                    },
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pincode',
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
                  CustomSizedBox(height: 20),
                  CustomText(
                    text: 'Job Type',
                    style: CustomTextStyle.normalBoldText,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Obx(
                            () => Radio<String>(
                              value: 'Part-Time',
                              groupValue:
                                  personalregisterController.jobType.value,
                              activeColor:
 Color(0xFF623089),
                              onChanged: (String? text) {
                              
                                personalregisterController.jobTypeGet(text!);
                                _jobType = text;
                                _validateForm();
                              },
                            ),
                          ),
                          CustomText(
                            text: 'Part-Time',
                            style: CustomTextStyle.normalText,
                          ),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Obx(
                            () => Radio<String>(
                              value: 'Full-Time',
                              activeColor: 
 Color(0xFF623089),
                              groupValue:
                                  personalregisterController.jobType.value,
                              onChanged: (String? text) {
                                personalregisterController.jobTypeGet(text!);
                                                                _jobType = text;

                                _validateForm();
                              },
                            ),
                          ),
                          CustomText(
                            text: 'Full-Time',
                            style: CustomTextStyle.normalText,
                          ),
                        ],
                      )),
                    ],
                  ),
                  CustomSizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Identity Proof',
                        style: CustomTextStyle.normalBoldText,
                      ),
                      SizedBox(width: 15),
                      CustomText(
                        text: 'Aadhar',
                        style: CustomTextStyle.identityGreyText,
                      ),
                      CustomSizedBox(height: 15),
                      IdentityProof(
                        onFileChosen: (File? image) async {
                          if (image != null) {
                            setState(() {
                              _isUploading = true;
                            });

                            _aadharFront = image;
                            final url = await imageUploader
                                .uploadAdharFrontImage(file: image);

                            if (url != null) {
                              personalregisterController
                                  .updateAadharFrontUrl(url);
                              setState(() {
                                _aadharFront = image;
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
                        label: 'Aadhar Front',
                        initialFile: File(
                            personalregisterController.aadharFrontUrl.value),
                      ),
                      CustomSizedBox(height: 20),
                      IdentityProof(
                        onFileChosen: (File? image) async {
                          if (image != null) {
                            setState(() {
                              _isUploading = true;
                            });

                            _aadharBack = image;
                            final url = await imageUploader
                                .uploadAdharBackImage(file: image);

                            if (url != null) {
                              personalregisterController
                                  .updateAadharBackUrl(url);
                              setState(() {
                                _aadharBack = image;
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
                        label: 'Aadhar Back',
                        initialFile: File(
                            personalregisterController.aadharBackUrl.value),
                      ),
                    ],
                  ),
                  CustomSizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isFormValid && !_isUploading
                        ? CustomButton(
                          height: 50,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                widget
                                    .onStepComplete(0); // Mark step as complete
                                widget.tabController?.animateTo(
                                    1); // Switch to Vehicle Information tab
                                savePersonalInfo();
                              }
                            },
                            child: CustomText(
                              text: 'Continue',
                              style: CustomTextStyle.buttonText,
                            ),
                          )
                        : CustomdisabledButton(
                            width: double.infinity,
                            height: 50,
                            borderRadius: BorderRadius.circular(20),
                            onPressed: _isUploading ? null : () {},
                            child: _isUploading
                                ? CircularProgressIndicator(
                                    color: 
 Color(0xFF623089)) // Show loading spinner during upload
                                : CustomText(
                                    text: 'Continue',
                                    style: CustomTextStyle.greyButtonText,
                                  ),
                          ),
                  ),
                  CustomSizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profileimageupdate.dart';
import 'package:miogra_service/Controller.dart/ProfileController/profilescreencontroller.dart';
import 'package:miogra_service/Shimmer/editscreenshimmer.dart';
import 'package:get/get.dart';
import 'package:miogra_service/Controller.dart/ProfileController/editprofilecontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/Validators.dart/validation.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textformfield.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isBasicExpanded = true;
  bool _isAddressExpanded = true;
  bool _isFormComplete = false; // Track form completeness
  final EditProfileController _profileUpdateController =
      Get.put(EditProfileController());
  final ProfilScreeenController profilScreeenController =
      Get.put(ProfilScreeenController());

  TextEditingController flatNoController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  Map<String, String> _initialValues = {}; // Store initial field values
  bool _isNewImagePicked = false; // Track new image pick state.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profilScreeenController.getProfile();

      _profileUpdateController.delPartName.value = username.toString();
      _profileUpdateController.emailId.value = useremail.toString();

      _profileUpdateController.mobNumb.value = mobilenumb.toString();

      var profileData = profilScreeenController.deliveryManpProfile.first;
      _profileUpdateController.flatNo.value =
          profileData['address']['houseNo'] ?? '';
      _profileUpdateController.delarea.value =
          profileData['address']['city'] ?? '';
      _profileUpdateController.nearBy.value =
          profileData['address']['landMark'] ?? '';
      _initialValues = {
        'name': _profileUpdateController.delPartName.value,
        'email': _profileUpdateController.emailId.value,
        'mobile': _profileUpdateController.mobNumb.value,
        'flatNo': _profileUpdateController.flatNo.value,
        'delarea': _profileUpdateController.delarea.value,
        'nearBy': _profileUpdateController.nearBy.value,
      };
      _updateFormState();
    });
  }

  bool isFormModified() {
    bool fieldsModified = _profileUpdateController.delPartName.value !=
            _initialValues['name'] ||
        _profileUpdateController.emailId.value != _initialValues['email'] ||
        _profileUpdateController.mobNumb.value != _initialValues['mobile'] ||
        _profileUpdateController.flatNo.value != _initialValues['flatNo'] ||
        _profileUpdateController.delarea.value != _initialValues['delarea'] ||
        _profileUpdateController.nearBy.value != _initialValues['nearBy'];
    bool imageModified =
        _isNewImagePicked || _profileUpdateController.pickedImage.value != null;
    return fieldsModified || imageModified;
  }

  bool isLoading = false;

  ProfileImageUploader profileImageUploader = Get.put(ProfileImageUploader());

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _imageError;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      int fileSizeInBytes = await imageFile.length();
      double fileSizeInKB = fileSizeInBytes / 1024;

      print(
          "Selected image size: $fileSizeInBytes bytes (${fileSizeInKB.toStringAsFixed(2)} KB)");

      if (fileSizeInKB > 1024) {
        setState(() {
          _imageError = "Please select an image less than 1MB.";
        });
        return;
      }

      setState(() {
        _imageFile = imageFile;
        _isNewImagePicked = true;
        _isFormComplete = isFormModified();
        _updateFormState();
        _imageError = null; // Clear error if valid
      });
    } else {
      setState(() {
        _imageError = "No image selected.";
      });
    }
  }

  final formkey = GlobalKey<FormState>();

  bool isFormComplete() {
    return _profileUpdateController.delPartName.value.isNotEmpty &&
        _profileUpdateController.emailId.value.isNotEmpty &&
        _profileUpdateController.mobNumb.value.isNotEmpty &&
        _profileUpdateController.flatNo.value.isNotEmpty &&
        _profileUpdateController.delarea.value.isNotEmpty &&
        _profileUpdateController.nearBy.value.isNotEmpty;
  }

  void _updateFormState() {
    setState(() {
      _isFormComplete = isFormModified();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryBottomNavigation(
                          showBottomSheet: false,
                          initialIndex: 3,
                        ))),
          ),
          title: Center(
              child: CustomText(
            text: 'Edit Profile          ',
            style: CustomTextStyle.screenTitle,
          ))),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Obx(() {
            if (profilScreeenController.dataLoading.value) {
              return Center(child: EditScreeenShimmer());
            }
            if (profilScreeenController.deliveryManpProfile.isEmpty) {
              return Center(child: Text('No Data Found'));
            }
            var profileData = profilScreeenController.deliveryManpProfile.first;
            var deliveryManImage = profileData['imgUrl'] ?? '';
            var deliverymanCountry = profileData['address']?['country'] ?? '';
            var deliveryManPostalcode =
                profileData['address']?['postalCode'] ?? '';
            var deliverymanregion = profileData['address']?['region'] ?? '';
            return Column(
              children: [
                CustomText(
                    text: 'Profile Image',
                    style: CustomTextStyle.mediumBoldBlackText),
                SizedBox(
                  height: 15,
                ),
                FormField(
                  builder: (state) {
                    return Column(
                      children: [
                        Center(
                            child: Stack(children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: _imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : (deliveryManImage.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              "$globalImageUrlLink${deliveryManImage}"),
                                          fit: BoxFit.cover,
                                        )
                                      : DecorationImage(
                                          image: AssetImage(
                                              'assets/images/delprofile.png'),
                                          fit: BoxFit.cover,
                                        )),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: const [
                                     Color(0xFFAE62E8),

 Color(0xFF623089)

                                    ],
                                  ),
                                ),
                                child: Image.asset('assets/images/edit.png'),
                              ),
                            ),
                          ),
                        ])),
                        if (_imageError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "*$_imageError!",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (_profileUpdateController.pickedImage.value ==
                                null &&
                            deliveryManImage == null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Please pick a profile image',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomContainer(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  width: MediaQuery.of(context).size.width / 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10, left: 10, right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isBasicExpanded = !_isBasicExpanded;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                    text: 'Basic Details',
                                    style: CustomTextStyle.mediumBoldBlackText),
                                Icon(
                                  _isBasicExpanded
                                      ? MdiIcons.chevronUp
                                      : MdiIcons.chevronDown,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isBasicExpanded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              CustomPriceTextFormField(
                                readOnly: false,
                                validator: validateName,
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Delivery Partner Name',
                                          style: CustomTextStyle
                                              .greyTextFormFieldText),
                                      TextSpan(
                                          text: ' ⁕',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17)),
                                    ],
                                  ),
                                ),
                                initialValue:
                                    _profileUpdateController.delPartName.value,
                                onChanged: (text) {
                                  _profileUpdateController.delPartName.value =
                                      text;
                                  _updateFormState();
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomPriceTextFormField(
                                style: TextStyle(color: Colors.black),
                                readOnly: true,
                                initialValue:
                                    _profileUpdateController.emailId.value,
                                validator: validateEmail,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Email ID',
                                          style: CustomTextStyle
                                              .greyTextFormFieldText),
                                      TextSpan(
                                          text: ' ⁕',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomPriceTextFormField(
                                readOnly: true,
                                style: TextStyle(color: Colors.black),
                                initialValue:
                                    _profileUpdateController.mobNumb.value,
                                validator: validatePhone,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Mobile Number',
                                          style: CustomTextStyle
                                              .greyTextFormFieldText),
                                      TextSpan(
                                          text: ' ⁕',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomContainer(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  width: MediaQuery.of(context).size.width / 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10, left: 10, right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAddressExpanded = !_isAddressExpanded;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                    text: 'Address',
                                    style: CustomTextStyle.mediumBoldBlackText),
                                Icon(
                                  _isAddressExpanded
                                      ? MdiIcons.chevronUp
                                      : MdiIcons.chevronDown,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isAddressExpanded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              CustomPriceTextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                readOnly: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a House number';
                                  }
                                  bool hasLetter =
                                      value.contains(RegExp(r'[a-zA-Z]'));
                                  bool hasDigit = value.contains(RegExp(r'\d'));

                                  if (!hasLetter || !hasDigit) {
                                    return 'Please Enter both House Number and Street';
                                  }
                                  return null;
                                },
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              'Flat / House no / Floor / Building',
                                          style: CustomTextStyle
                                              .greyTextFormFieldText),
                                      TextSpan(
                                          text: ' ⁕',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17)),
                                    ],
                                  ),
                                ),
                                initialValue:
                                    _profileUpdateController.flatNo.value,
                                onChanged: (text) {
                                  _profileUpdateController.flatNo.value = text;
                                  _updateFormState();
                                },
                                //  validator: validateRestaurantName
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomPriceTextFormField(
                                readOnly: false,
                                style: TextStyle(color: Colors.black),
                                initialValue:
                                    _profileUpdateController.delarea.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an area';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {
                                  _profileUpdateController.delarea.value = text;
                                  _updateFormState();
                                },
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Area / Sector / Locality',
                                          style: CustomTextStyle
                                              .greyTextFormFieldText),
                                      TextSpan(
                                          text: ' ⁕',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomPriceTextFormField(
                                readOnly: false,
                                style: TextStyle(color: Colors.black),
                                initialValue:
                                    _profileUpdateController.nearBy.value,
                                onChanged: (text) {
                                  _profileUpdateController.nearBy.value = text;
                                  _updateFormState();
                                },
                                // validator: validatePhone,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                label: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Nearby landmark ',
                                          style: CustomTextStyle
                                              .greyTextFormFieldText),
                                      TextSpan(
                                          text: ' ⁕',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 17)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _isFormComplete && isFormComplete()
                    ? CustomButton(
                        borderRadius: BorderRadius.circular(20),
                        height: MediaQuery.of(context).size.height / 24,
                        width: MediaQuery.of(context).size.width / 2.1,
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            if (_imageFile != null) {
                              // Show error if no image is picked.
                              _profileUpdateController.pickImages(_imageFile!);
                              _profileUpdateController
                                  .updateImageUrl(_imageFile!.path);
                            }

                            setState(() {
                              isLoading =
                                  true; // Show CircularProgressIndicator
                            });

                            await Future.delayed(Duration(seconds: 3));

                            if (isFormModified()) {
                              Map<String, dynamic> addressList = {
                                "district": profilScreeenController
                                    .deliveryManpProfile[0]["district"],
                                "companyName": profilScreeenController
                                    .deliveryManpProfile[0]["companyName"],
                                "fullAddress": profilScreeenController
                                    .deliveryManpProfile[0]["fullAddress"],
                                "street": profilScreeenController
                                    .deliveryManpProfile[0]["street"],
                                "state": profilScreeenController
                                    .deliveryManpProfile[0]["state"],
                                "country": deliverymanCountry,
                                "postalCode": deliveryManPostalcode,
                                "contactPerson": profilScreeenController
                                    .deliveryManpProfile[0]["contactPerson"],
                                "contactPersonNumber": profilScreeenController
                                        .deliveryManpProfile[0]
                                    ["contactPersonNumber"],
                                "addressType": profilScreeenController
                                    .deliveryManpProfile[0]["addressType"],
                                "latitude": profilScreeenController
                                    .deliveryManpProfile[0]["latitude"],
                                "longitude": profilScreeenController
                                    .deliveryManpProfile[0]["longitude"],
                                "region": deliverymanregion,
                                "city": _profileUpdateController.delarea.value,
                                "houseNo":
                                    _profileUpdateController.flatNo.value,
                                "landMark":
                                    _profileUpdateController.nearBy.value,
                              };
                              _profileUpdateController.updateProfileScreen(
                                  _profileUpdateController.delPartName.value,
                                  _profileUpdateController
                                          .savedImage.value.isNotEmpty
                                      ? profileImageUploader.imageURL.value
                                      : deliveryManImage,
                                  addressList);
                            }
                          } else {}
                          setState(() {
                            isLoading =
                                false; // Revert to original button state
                          });
                        },
                        child: isLoading
                            ? SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : CustomText(
                                text: 'Update',
                                style: CustomTextStyle.updateButtonText,
                              ),
                      )
                    : CustomdisabledButton(
                        borderRadius: BorderRadius.circular(20),
                        height: MediaQuery.of(context).size.height / 23,
                        width: MediaQuery.of(context).size.width / 2,
                        onPressed: () {
                          if (formkey.currentState!.validate()) {}
                        },
                        child: Text(
                          'Update',
                          style: CustomTextStyle.updateGreyButtonText,
                        )),
                SizedBox(
                  height: 20,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

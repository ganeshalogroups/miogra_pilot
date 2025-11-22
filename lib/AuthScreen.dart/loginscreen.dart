// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Controller.dart/AuthController.dart/logincontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/tokencontroller.dart';
import 'package:miogra_service/Validators.dart/validation.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:miogra_service/AuthScreen.dart/otpscreen.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController countryController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  TokenController tokenController = Get.put(TokenController());
  bool isLoading = false;
  String? _validationMessage;
  bool isButtonEnabled = false;

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController(text: "+91");
    phoneController = TextEditingController();
    phoneController.addListener(() {
      final validationMessage = validatePhone(phoneController.text);
      setState(() {
        _validationMessage = validationMessage;
        isButtonEnabled = validationMessage == null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CustomContainer(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Gemini_Generated_Image_xoc37cxoc37cxoc3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.1,
                  child: Stack(
                    children: [
                      // Frosted glass effect background
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                      // Actual content
                      Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                        child: CustomContainer(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                                width: 1.0, // Reduced the thickness here
                              ), // Underline border
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              CustomText(
                                text: 'Your Delivery\nJourney Starts Here',
                                style: CustomTextStyle.bigWhiteText,
                              ),
                              CustomSizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: CustomText(
                                  text:
                                      'Get ready to deliver smiles! Embark on a seamless journey of speed, reliability, and trust.',
                                  style: CustomTextStyle.smallWhiteText,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              CustomSizedBox(height: 5),
                              Column(
                                children: [
                                  CustomContainer(
                                    height: 55,
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors
                                              .white, // Set the color of the bottom border
                                          width:
                                              1.0, // Reduced the thickness here
                                        ),
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomContainer(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                              'assets/images/India.png'),
                                        ),
                                        SizedBox(width: 8),
                                        SizedBox(
                                          width: 35,
                                          child: TextFormField(
                                            maxLength: 3,
                                            buildCounter: (BuildContext context,
                                                {int? currentLength,
                                                bool? isFocused,
                                                int? maxLength}) {
                                              return null; // This removes the counter text
                                            },
                                            controller: countryController,
                                            style:
                                                TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height:
                                              30, // Increased height of the line
                                          width:
                                              1.2, // Reduced width of the line
                                          color: Colors.white, // Line color
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.6,
                                          child: TextFormField(
                                            controller: phoneController,
                                            maxLength: 10,
                                            buildCounter: (BuildContext context,
                                                {int? currentLength,
                                                bool? isFocused,
                                                int? maxLength}) {
                                              return null; // This removes the counter text
                                            },
                                            style:
                                                TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.phone,
                                            validator: (value) {
                                              final validationMessage =
                                                  validatePhone(value);
                                              setState(() {
                                                _validationMessage =
                                                    validationMessage;
                                              });
                                              return validationMessage;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'Enter Mobile Number',
                                              labelStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
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
                                            color:
                                                Color.fromARGB(255, 158, 15, 5),
                                            fontSize: 10),
                                      ),
                                    ),
                                ],
                              ),
                              CustomSizedBox(height: 15),
                              CustomButton(
                                height: 50,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                                onPressed: () {
                                  setState(() {
                                    _validationMessage =
                                        validatePhone(phoneController.text);
                                    isButtonEnabled =
                                        _validationMessage == null;
                                  });

                                  if (_validationMessage == null) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    Future.delayed(const Duration(seconds: 20),
                                        () {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });

                                    loginController.requestOtpApi(
                                        mobileNo: phoneController.text,
                                    );
                                         setState(() {
                                         isLoading = false;
                                       });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OtpScreen(
                                            phoneNumber: phoneController.text),
                                      ),
                                    ).then((_) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  } else {}
                                },
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white)
                                    : CustomText(
                                        text: 'Get Started',
                                        style: CustomTextStyle.buttonText,
                                      ),
                              ),
                              CustomSizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

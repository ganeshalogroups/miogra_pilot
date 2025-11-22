// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Controller.dart/AuthController.dart/logincontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/tokencontroller.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final CountdownController _controller = CountdownController(autoStart: true);
  bool hasClickedButton = false;
  bool _showResendText = false;
  bool _isCountdownFinished = false; // Flag to check if countdown is finished
  bool isLoading = false;
  String? _errorMessage;

  final TextEditingController _otpNum = TextEditingController();
  LoginController otpController = Get.put(LoginController());
  TokenController tokenController = Get.put(TokenController());

  final otpKey = GlobalKey<FormState>();

  void onFinished() {
    setState(() {
      hasClickedButton = false;
      _showResendText = true;
      _otpNum.clear();
      _errorMessage = null;
      _isCountdownFinished = true; // Set flag when countdown is finished
    });
  }

  @override
  void dispose() {
    _otpNum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Gemini_Generated_Image_xoc37cxoc37cxoc3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: otpKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Stack(
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomContainer(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'OTP Verification',
                              style: CustomTextStyle.bigWhiteText,
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              text: 'We have sent a verification code to',
                              style: CustomTextStyle.smallWhiteText,
                            ),
                            CustomText(
                              text: '+91-${widget.phoneNumber}',
                              fontSize: 17,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: SizedBox(
                                height: 49.5,
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: PinCodeTextField(
                                  pinTheme: PinTheme(
                                    activeColor: Colors.white,
                                    inactiveColor:
                                        Colors.white.withOpacity(0.5),
                                    selectedColor: Colors.white,
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10),
                                    borderWidth: 2,
                                    fieldHeight: 50,
                                    fieldWidth: 50,
                                    activeFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    inactiveFillColor: Colors.white,
                                  ),
                                  length: 4,
                                  keyboardType: TextInputType.number,
                                  enableActiveFill: true,
                                  autoFocus: true,
                                  controller: _otpNum,
                                  appContext: context,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            if (_errorMessage != null &&
                                _otpNum.text.length < 4)
                              Center(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            _showResendText
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: "Didn't receive the OTP? ",
                                          style: CustomTextStyle.smallWhiteText,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showResendText = false;
                                              _controller.restart();
                                              _isCountdownFinished =
                                                  false; // Reset flag when OTP is resent
                                              otpController.requestOtpApi(
                                                  mobileNo: widget.phoneNumber);
                                            });
                                          },
                                          child: CustomText(
                                            text: 'Resend OTP',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Countdown(
                                    controller: _controller,
                                    seconds: 59,
                                    build: (_, double time) {
                                      String formattedTime =
                                          time.toInt().toString();
                                      if (formattedTime.length == 1) {
                                        formattedTime = '0$formattedTime';
                                      }
                                      return Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              "Didn't receive the OTP? Retry in 00.$formattedTime",
                                              style: CustomTextStyle
                                                  .smallWhiteText,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onFinished: onFinished,
                                  ),
                            SizedBox(height: 5),
                            CustomButton(
                              onPressed: () async {
                                if (_isCountdownFinished) {
                                  setState(() {
                                    _errorMessage =
                                        "OTP has expired. Please resend OTP.";
                                    _otpNum.clear();
                                  });
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                  _errorMessage = null;
                                });

                                bool isVerified = await otpController.verifyotp(
                                  contactNum: widget.phoneNumber,
                                  otp: _otpNum.text,
                                  otpId: otpController.logindata["data"]
                                      ["otpId"],
                                );
                                if (isVerified) {
                                  tokenController.tokenapi(
                                    mobileNo: widget.phoneNumber,
                                  );
                                } else {
                                  setState(() {
                                    _otpNum.clear();
                                    _errorMessage =
                                        "OTP you entered is invalid. Please retry.";
                                    isLoading = false;
                                  });
                                }
                              },
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(20),
                              child: Obx(
                                () => otpController.isLoading.value
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : CustomText(
                                        text: 'Verify',
                                        style: CustomTextStyle.buttonText,
                                      ),
                              ),
                            ),
                            CustomSizedBox(height: 35),
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
    );
  }
}

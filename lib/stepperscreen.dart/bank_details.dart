// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Controller.dart/AuthController.dart/registercontroller.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textformfield.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BankDetailScreen extends StatefulWidget {
  final Function(int) onStepComplete;
  final TabController? tabController;
  final String? initialBankName;
  final String? initialAccountType;
  final String? initialAccountNumber;
  final String? initialReEnterAccountNumber;
  final String? initialIfscCode;

  const BankDetailScreen({
    super.key,
    required this.onStepComplete,
    this.tabController,
    this.initialBankName,
    this.initialAccountType,
    this.initialAccountNumber,
    this.initialReEnterAccountNumber,
    this.initialIfscCode,
  });

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
    final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _reEnterAccountNumberController =
      TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  String? _validationMessage;
  String? _panvalidationMessage;

  final List<String> _accountTypes = ['Current', 'Savings'];
  String? _selectedAccountType;
  bool _isAllFieldsFilled = false;
  final bankformkey = GlobalKey<FormState>();
  bool isLoading = false;
  RegisterController bankRegisterController = Get.put(RegisterController());
  void saveBankDetails() {
    bankRegisterController.bankDetails.update((details) {
      details?.accountType = _accountTypeController.text;
      details?.accountNumber = _accountNumberController.text;
      details?.ifscCode = _ifscCodeController.text;
      details?.pan = _panController.text;
      details?.bankName = _bankNameController.text;
      details?.branchName = _branchNameController.text;
      details?.beneficiaryName = _beneficiaryNameController.text;
    });
    bankRegisterController.updateBankDetailsStatus(_isAllFieldsFilled);
  }

  @override
  void initState() {
    super.initState();
      _beneficiaryNameController.text = bankRegisterController.beneficiaryName.value;
    _bankNameController.text = bankRegisterController.bankName.value;
    _branchNameController.text = bankRegisterController.branchName.value;
    _accountTypeController.text = bankRegisterController.acctype.value;
    _accountNumberController.text = bankRegisterController.accNumb.value;
    _reEnterAccountNumberController.text =
        bankRegisterController.reAccNumb.value;
    _ifscCodeController.text = bankRegisterController.ifscCode.value;
    _panController.text = bankRegisterController.pan.value;

    _checkIfAllFieldsFilled();
  }

  @override
  void dispose() {
     _beneficiaryNameController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountTypeController.dispose();
    _accountNumberController.dispose();
    _reEnterAccountNumberController.dispose();
    _ifscCodeController.dispose();
    _panController.dispose();
    super.dispose();
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      // String? ifsc = validateIFSC(_ifscCodeController.text);
      // String? pancard = validatePAN(_panController.text);

      _isAllFieldsFilled = _bankNameController.text.isNotEmpty &&  _beneficiaryNameController.text.isNotEmpty &&
      _branchNameController.text.isNotEmpty &&
          _accountTypeController.text.isNotEmpty &&
          _accountNumberController.text.isNotEmpty &&
          _reEnterAccountNumberController.text.isNotEmpty &&
          //  pancard ==null &&
          // ifsc == null;
          _panvalidationMessage==null && _validationMessage == null;
    });
    bankRegisterController.updateBankDetailsStatus(_isAllFieldsFilled);
  }

  void _showAccountTypeDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(
                  height: 10,
                ),
                Center(
                  child: CustomContainer(
                    height: 6,
                    width: 50,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.grey,
                  ),
                ),
                CustomSizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Select Account Type',
                    style: CustomTextStyle.normalBoldText,
                  ),
                ),
                CustomSizedBox(
                  height: 15,
                ),
                Column(
                  children: _accountTypes.map((type) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAccountType = type;
                          _accountTypeController.text = type;
                          bankRegisterController.acctypeGet(type.toUpperCase());
                        });
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: ListTile(
                        leading: Radio<String>(
                          value: type,
                          groupValue: _selectedAccountType,
                          activeColor: 
 Color(0xFF623089),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedAccountType = value;
                                _accountTypeController.text = value;
                                bankRegisterController.acctypeGet(value);
                              });
                              Navigator.pop(context); // Close the bottom sheet
                            }
                          },
                        ),
                        title: Text(type),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your account number';
    } else if (!RegExp(r'^[0-9]{10,16}$').hasMatch(value)) {
      return 'Please enter a valid account number (10-16 digits)';
    }
    return null;
  }

  String? _validateReEnterAccountNumber(String? value) {
    if (value != _accountNumberController.text) {
      return 'Account numbers do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: bankformkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CustomText(
                        text: 'Bank Details',
                        style: CustomTextStyle.mediumBoldText,
                      ),
                    ),
                     CustomTextFormField(
                      controller: _beneficiaryNameController,
                      onChanged: (text) {
                        bankRegisterController.beneficiaryNameGet(text);
                        _checkIfAllFieldsFilled();
                      },
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Beneficiary Name',
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
                    CustomSizedBox(height: 30),
                    CustomTextFormField(
                      controller: _bankNameController,
                      onChanged: (text) {
                        bankRegisterController.bankNameGet(text);
                        _checkIfAllFieldsFilled();
                      },
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Bank Name',
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
                    CustomSizedBox(height: 30),
                     CustomTextFormField(
                      controller: _branchNameController,
                      onChanged: (text) {
                        bankRegisterController.branchNameGet(text);
                        _checkIfAllFieldsFilled();
                      },
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Branch Name',
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
                    CustomSizedBox(height: 30),
                    AccountTextField(
                      controller: _accountTypeController,
                      onChanged: (text) {
                        bankRegisterController.acctypeGet(text);
                        _checkIfAllFieldsFilled();
                      },
                      readOnly: true,
                      onTap: _showAccountTypeDropdown,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'A/C Type',
                              style: CustomTextStyle.labelText,
                            ),
                            TextSpan(
                              text: ' ⁕',
                              style: CustomTextStyle.starText,
                            ),
                          ],
                        ),
                      ),
                      suffixIcon: Icon(
                        MdiIcons.chevronDown,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    CustomSizedBox(height: 20),
                    CustomTextFormField(
                      controller: _accountNumberController,
                      onChanged: (text) {
                        bankRegisterController.accNumbGet(text);
                        _checkIfAllFieldsFilled();
                      },
                      validator: validateAccountNumber,
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Account Number',
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
                      controller: _reEnterAccountNumberController,
                      validator: _validateReEnterAccountNumber,
                      onChanged: (text) {
                        bankRegisterController.reAccNumbGet(text);
                        _validateReEnterAccountNumber(text);
                        _checkIfAllFieldsFilled();
                      },
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Re-enter Account Number',
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
                      controller: _ifscCodeController,
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
                        return validateIFSC(value);
                      },
                      onChanged: (text) {
                        _validationMessage =
                            validateIFSC(_ifscCodeController.text);
                        bankRegisterController.ifscCode(text);
                        _checkIfAllFieldsFilled();
                      },
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'IFSC Code',
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
                            fontSize: 10,
                          ),
                        ),
                      ),
                    CustomSizedBox(height: 20),
                    CustomTextFormField(
                      controller: _panController,
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
                        return validatePAN(value);
                      },
                      onChanged: (text) {
                        _panvalidationMessage =
                            validatePAN(_panController.text);
                        bankRegisterController.pan(text);
                        _checkIfAllFieldsFilled();
                      },
                      labelText: null,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'PAN Number',
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

                  
                    if (_panvalidationMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _panvalidationMessage!,
                          style: TextStyle(
                            color: Color.fromARGB(255, 158, 15, 5),
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                CustomSizedBox(height: 50),
                if (_isAllFieldsFilled)
                  CustomButton(
                    height: 50,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () {
                      if (bankformkey.currentState!.validate()) {
                        widget.onStepComplete(2); // Mark step as complete
                        widget.tabController
                            ?.animateTo(3); // Switch to Vehicle Information tab
                        saveBankDetails();
                      }
                    },
                    child: CustomText(
                      text: 'Continue',
                      style: CustomTextStyle.buttonText,
                    ),
                  )
                else
                  CustomdisabledButton(
                    height: 50,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(20),
                    onPressed: () {},
                    child: CustomText(
                      text: 'Continue',
                      style: CustomTextStyle.greyButtonText,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an IFSC code';
    }
    // Regex pattern for IFSC code
    final regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid IFSC code';
    }
    return null;
  }
  
  String? validatePAN(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter PAN number';
  }

  // 4th letter must be 'P'
  final RegExp panRegExp = RegExp(r'^[A-Z]{3}P[A-Z][0-9]{4}[A-Z]$');

  if (!panRegExp.hasMatch(value.toUpperCase())) {
    return 'Please enter a valid PAN number (4th letter must be P, e.g. ABCPD1234E)';
  }

  return null; // ✅ valid
}

}

// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Controller.dart/AuthController.dart/regioncontroller.dart';
import 'package:miogra_service/Controller.dart/AuthController.dart/registercontroller.dart';
import 'package:miogra_service/Model.dart/RegisterModel.dart/getregionmodel.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_disablebutton.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkSetup extends StatefulWidget {
  final Function(int) onStepComplete;
  final TabController? tabController;
  final String? initialSelectedLocation;
  final bool initialDeliveryBag;
  final bool initialTShirt;

  const WorkSetup({
    super.key,
    required this.onStepComplete,
    this.tabController,
    this.initialSelectedLocation,
    this.initialDeliveryBag = false,
    this.initialTShirt = false,
  });

  @override
  State<WorkSetup> createState() => _WorkSetupState();
}

class _WorkSetupState extends State<WorkSetup> {
  String? _selectedLocation;
  bool _deliveryBag = false;
  bool _tShirt = false;
  bool isLoading = false;
  late RegisterController workRegisterController;

  final RegionController regionController = Get.put(RegionController());
  final workformkey = GlobalKey<FormState>();

  Map<String, List<String>> regionDetails = {};
  final Map<String, bool> _regionVisibility = {};

  bool get isFormValid => _selectedLocation != null;

  @override
  void initState() {
    super.initState();
    workRegisterController = Get.put(RegisterController());

    _selectedLocation = workRegisterController.regionData.value;
    _deliveryBag = workRegisterController.deliveryBag.value;
    _tShirt = workRegisterController.tShirt.value;

    fetchRegionData();
  }

  void fetchRegionData() async {
    setState(() {
      isLoading = true;
    });

    await regionController.getRegion();

    setState(() {
      isLoading = false;
      for (var region in regionController.regions) {
        if (region.regionName != null) {
          regionDetails[region.regionName!] = [
            'Region Details',
            //'Total Radius: 30km',
            'Pincodes: ${region.regionPincodes?.join(', ') ?? "No pincodes available"}', // Handle nullable pincodes
            // 'Areas: Nagercoil, Vadsery, Krishnankovil, Chettikulam'
          ];

          _regionVisibility[region.regionName!] =
              false; // Ensure regionName is not null
        }
      }
    });
  }

  List<String> getPincodes(String regionName) {
    var region = regionController.regions.firstWhere(
      (region) => region.regionName == regionName,
      orElse: () => Datum(
          regionName: '', regionPincodes: []), // Provide a default if no match
    );
    return region.regionPincodes ??
        []; // Return an empty list if regionPincodes is null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: 
 Color(0xFF623089)))
          : SingleChildScrollView(
              child: Form(
                key: workformkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 20, left: 20, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: 'Work Setup',
                                  style: CustomTextStyle.mediumBoldText),
                              CustomSizedBox(height: 20),
                              CustomText(
                                text: 'Select the Region you want to work in',
                                style: CustomTextStyle.normalBoldText,
                              ),
                              CustomSizedBox(height: 10),
                              SizedBox(
                                child: CustomText(
                                    overflow: TextOverflow.clip,
                                    text:
                                        'Discover opportunities in your preferred region for a fulfilling work experience.',
                                    style: CustomTextStyle.captionText),
                              ),
                              CustomSizedBox(height: 20),
                              for (var region in regionController.regions)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                value: region.regionName ?? ' ',
                                                groupValue: _selectedLocation,
                                                activeColor: 
 Color(0xFF623089),
                                                onChanged: (String? text) {
                                                  setState(() {
                                                    _selectedLocation = text!;
                                                    workRegisterController
                                                        .regionGet(
                                                            text,
                                                            region.userId ??
                                                                '');
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      region.regionName ?? '',
                                                      style: CustomTextStyle
                                                          .regionText)),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(_regionVisibility[
                                                  region.regionName ?? '']!
                                              ? Icons.expand_less
                                              : Icons.expand_more),
                                          onPressed: () {
                                            setState(() {
                                              _regionVisibility[
                                                      region.regionName ?? ''] =
                                                  !_regionVisibility[
                                                      region.regionName ?? '']!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          _regionVisibility[region.regionName]!,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: regionDetails[
                                                  region.regionName]!
                                              .map((detail) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 26.0),
                                                    child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 4),
                                                      dense:
                                                          true, // Reduce space between tiles
                                                      title: CustomText(
                                                        text: detail,
                                                        style: detail ==
                                                                'Region Details'
                                                            ? CustomTextStyle
                                                                .regionText
                                                            : CustomTextStyle
                                                                .smallGreyText,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              CustomSizedBox(height: 20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: CustomText(
                            text: 'Apply Delivery Kit',
                            style: CustomTextStyle.normalBoldText,
                          ),
                        ),
                        CustomSizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: CustomText(
                            text:
                                'Ready to go the extra mile? Check off the essentials and shine!',
                            style: CustomTextStyle.captionText,
                          ),
                        ),
                        CustomSizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: CheckboxListTile(
                            title: CustomText(
                              text: 'Delivery bag',
                              style: CustomTextStyle.normalBoldText,
                            ),
                            value: _deliveryBag,
                            activeColor: 
 Color(0xFF623089),
                            onChanged: (bool? value) {
                              setState(() {
                                _deliveryBag = value!;
                                workRegisterController.updateDeliveryBag(value);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: CheckboxListTile(
                            title: CustomText(
                              text: 'T-Shirt',
                              style: CustomTextStyle.normalBoldText,
                            ),
                            value: _tShirt,
                            activeColor: 
 Color(0xFF623089),
                            onChanged: (bool? value) {
                              setState(() {
                                _tShirt = value!;
                                workRegisterController.updateTShirt(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Obx(() {
                        return isFormValid &&
                                workRegisterController
                                    .isPersonalInfoCompleted.value &&
                                workRegisterController
                                    .isVehicleInfoCompleted.value &&
                                workRegisterController
                                    .isBankDetailsCompleted.value &&
                                _selectedLocation!.isNotEmpty
                            ? CustomButton(
                              height: 50,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                                onPressed: () {
                                  if (workformkey.currentState!.validate()) {
                                    List<String> pincodes =
                                        getPincodes(_selectedLocation!);
                                    widget.onStepComplete(3);
                                    workRegisterController.registerApi(
                                        pinCode: pincodes,
                                        selectedLocation: _selectedLocation!,
                                        deliveryBag: _deliveryBag,
                                        dress: _tShirt);
                                  }
                                },
                                child: CustomText(
                                  text: 'Raise Request',
                                  style: CustomTextStyle.buttonText,
                                ),
                              )
                            : CustomdisabledButton(
                                width: double.infinity,
                                height: 50,
                                borderRadius: BorderRadius.circular(20),
                                onPressed: () {},
                                child: CustomText(
                                  text: 'Raise Request',
                                  style: CustomTextStyle.greyButtonText,
                                ),
                              );
                      }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

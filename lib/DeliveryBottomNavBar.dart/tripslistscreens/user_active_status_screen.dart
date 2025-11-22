import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/ProfileController/activestatusupdate.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Controller.dart/ProfileController/depositcontroller.dart';
import '../../widgets.dart/custom_textstyle.dart';

class UserActiveStatusDesign extends StatefulWidget {
  final bool pendingRequest;
  const UserActiveStatusDesign({super.key, required this.pendingRequest});

  @override
  State<UserActiveStatusDesign> createState() => _UserActiveStatusDesignState();
}

class _UserActiveStatusDesignState extends State<UserActiveStatusDesign> {
  final ActiveStatusController _activeStatusUpdatecontroller =
      Get.put(ActiveStatusController());
  final DepositController _depositUpdatecontroller =
      Get.put(DepositController());
  bool _isLoading = false;
  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBar(message: message),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  String? vendorId;
  final storage = GetStorage();

  void _toggleSwitch() async {
    if (widget.pendingRequest == true) {
      _showNotification('Your request is under review');
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await Future.delayed(Duration(seconds: 1));

        setState(() {
          switchValue = !switchValue;
          storage.write('switchStatus', switchValue);
          

          DateTime now = DateTime.now();
          String formattedStartDateTime = DateFormat('MM-dd-yyyy').format(now);
          String formattedEndDateTime = DateFormat('MM-dd-yyyy').format(now);

          if (!switchValue) {
            _activeStatusUpdatecontroller.updatActiveStatus("offline");
            // storage.write('isdelactive',switchValue);  
            _depositUpdatecontroller.updateDeposit(
                formattedStartDateTime, formattedEndDateTime, vendorId ?? '');
            if (vendorId == null) {
              return;
            }

            // print('vendor id .............${ vendorId}');
          } else {
            _activeStatusUpdatecontroller.updatActiveStatus("online");
            if (vendorId == null) {
              return;
            }
            // _depositUpdatecontroller.updateDeposit(
            //     formattedStartDateTime, null, vendorId ?? '');
          }
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  dynamic depositeData = [];

  @override
  void initState() {
    final depositProvider = context.read<DepositProviderPagin>();
    depositProvider.fetchEarningData(
        startdate: "01-01-2020", endDate: TimerService().apiCallDate());
    depositeData = depositProvider.fetchedDatas;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Hello, Welcome',
                  style: CustomTextStyle.helloText,
                ),
                Text(
                  widget.pendingRequest == true
                      ? ''
                      : (username.toString().isNotEmpty
                          ? '${username.toString()[0].toUpperCase()}${username.toString().substring(1)}'
                          : ''),
                  style: CustomTextStyle.mediumBoldText,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                if (depositeData.isEmpty) {
                  _isLoading ? null : _toggleSwitch();
                } 
                else {
                  if (depositeData[0]["depositStatus"] == "request" ||
                      depositeData[0]["depositStatus"] == "pending") {
                    // if (switchValue == false) {
                    //   Get.snackbar('', '',
                    //       titleText: Text(
                    //         "Update User Failed",
                    //         style: CustomTextStyle.tripText,
                    //       ),
                    //       messageText: Text(
                    //         "You must deposit the pending amount.",
                    //         style: CustomTextStyle.tripText,
                    //       ));
                    // } 
                    
                  //  else {
                      _isLoading ? null : _toggleSwitch();
                   // }
                  } else {
                    _isLoading ? null : _toggleSwitch();
                  }
                }
              },
              //  onTap: _isLoading ? null : _toggleSwitch,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: switchValue ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: switchValue
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: switchValue ? 8 : 27,
                      right: switchValue ? 27 : 8,
                      top: 4,
                      bottom: 4,
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 1.5,
                                ),
                              )
                            : Text(
                                switchValue ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

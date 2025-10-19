import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackToOrder extends StatefulWidget {
  const BackToOrder({super.key});

  @override
  State<BackToOrder> createState() => _BackToOrderState();
}

class _BackToOrderState extends State<BackToOrder> {
  final OrderOnProcessController orderOnProcessController =
      Get.put(OrderOnProcessController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset('assets/images/checkgif.gif')),
              CustomText(
                  text: 'You Done a Great Job!',
                  style: CustomTextStyle.doneGreatJob),
              CustomSizedBox(height: 20),
              CustomText(
                  text:
                      'Another happy customer, thanks to you!\nGet ready for the next adventure!',
                  style: CustomTextStyle.happyCust),
              CustomSizedBox(height: 25),
              CustomButton(
                borderRadius: BorderRadius.circular(20),
                width: MediaQuery.of(context).size.width / 2,
                onPressed: () {
                  orderOnProcessController.orderOnProcessStatus(startdate: currentDateGlobal, enddate: currentDateGlobal);
                  Get.offAll(DeliveryBottomNavigation(
                      initialIndex: 0, showBottomSheet: false));
                },
                child: CustomText(
                    text: 'Back to Order',
                    style: CustomTextStyle.backToOrderButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';

class DepositNoDataScreen extends StatefulWidget {
  final String formattedDate;
  const DepositNoDataScreen({super.key, required this.formattedDate});

  @override
  State<DepositNoDataScreen> createState() => _DepositNoDataScreenState();
}

class _DepositNoDataScreenState extends State<DepositNoDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomContainer(
              backgroundColor: Colors.white60,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Cash in Hand',
                              style: CustomTextStyle.labelText,
                            ),
                            CustomSizedBox(height: 8),
                            CustomText(
                              text: '₹ 0.0',
                              style: CustomTextStyle.redAmountText,
                            ),
                          ],
                        ),
                        SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Due Date',
                              style: CustomTextStyle.labelText,
                            ),
                            CustomSizedBox(height: 8),
                            CustomText(
                              text: widget.formattedDate,
                              style: CustomTextStyle.stepTitleText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomSizedBox(height: 8),
                    CustomText(
                      text: 'Deposit cash when you reach limit',
                      style: CustomTextStyle.blueAmountText,
                    ),
                    CustomSizedBox(height: 8),
                    Divider(),
                    CustomSizedBox(height: 10),
                    CustomText(
                      text: 'Unpaid cash will be deducted from the next payout',
                      style: CustomTextStyle.redSmallText,
                    ),
                    CustomSizedBox(height: 20),
                    Center(
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(20),
                        width: double.infinity,
                        onPressed: () {},
                        child: CustomText(
                          text: 'Pay',
                          style: CustomTextStyle.buttonText,
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

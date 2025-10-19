// ignore_for_file: unnecessary_string_interpolations

import 'package:miogra_service/widgets.dart/custom_button.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';

class DepositrequestDatScreen extends StatefulWidget {
  final String depositStatus;
  final String totalAmount;
  final String formattedStartDateTime;
  const DepositrequestDatScreen(
      {super.key,
      required this.depositStatus,
      required this.totalAmount,
      required this.formattedStartDateTime});

  @override
  State<DepositrequestDatScreen> createState() =>
      _DepositrequestDatScreenState();
}

class _DepositrequestDatScreenState extends State<DepositrequestDatScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
                        text: widget.depositStatus == "request"
                            ? '₹ ${widget.totalAmount}'
                            : '₹ 0.0',
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
                        text: '${widget.formattedStartDateTime}',
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
    );
  }
}





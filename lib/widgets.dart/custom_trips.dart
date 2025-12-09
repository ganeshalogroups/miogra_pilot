import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTrips extends StatefulWidget {
  final String deliverytext;
  final String orderId;
  final dynamic ispaid;
  dynamic dateText;
  dynamic timeText;
  final dynamic tripAmount;
  dynamic tripTime;
  final dynamic tripKm;
  final dynamic rating;
  final int itemCount;
   bool  isfromTransactionDetails;
   CustomTrips(
      {super.key,
      required this.deliverytext,
      required this.orderId,
     this.ispaid,
      required this.dateText,
      required this.timeText,
      required this.tripAmount,
      required this.tripTime,
      required this.tripKm,
      required this.rating,
      this.isfromTransactionDetails = false,
      required this.itemCount});

  @override
  State<CustomTrips> createState() => _CustomTripsState();
}

class _CustomTripsState extends State<CustomTrips> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
               color: Customcolors.decorationpureWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    offset: const Offset(
                        0, 4), // Horizontal offset: 0, Vertical offset: 4
                    blurRadius: 1, // Blur radius
                    spreadRadius: 0, // Spread radius
                  ),
                ],
              ),

              // height: MediaQuery.of(context).size.height/7,
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: widget.deliverytext,
                          style: CustomTextStyle.delTypeText,
                        ),
                        Spacer(),
                        CustomText(
                            text: 'Order ID : #${widget.orderId}',
                            style: CustomTextStyle.orderblueAmountText),
                      ],
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:formattedDate(dateStr: widget.dateText),
                                style: CustomTextStyle.greyText,
                              ),
                              TextSpan(
                                text: ' | ',
                                style: CustomTextStyle.identityGreyText,
                              ),
                              TextSpan(
                                  text:formatDate(dateStr: widget.timeText),
                                  style: CustomTextStyle.greyText)
                            ],
                          ),
                        ),
                         Spacer(),
                          RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Payment :" ,
                                style:TextStyle(
      color: Colors.grey,
      fontSize: 11.5,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins-Medium')
                              ),
                              WidgetSpan(
        child: SizedBox(width: 8), // space between texts
      ),
                              TextSpan(
                                  text:widget.ispaid? "Settled":"Pending",
                                  style:TextStyle(
      color:widget.ispaid? Colors.green : Colors.red,
      fontSize: 11.5,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins-Medium'))
                            ],
                          ),)
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                          CustomText(
                              text: 'Trip Cost',
                              style: CustomTextStyle.smallNorText,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹',
                                    style: CustomTextStyle.stepTitleText,
                                  ),
                                  TextSpan(
                                    text: widget.tripAmount.toStringAsFixed(2),
                                    style: CustomTextStyle.tripnumbText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                       widget.isfromTransactionDetails? Column(
                          children: [
                            CustomText(
                                text: 'Tip Cost',
                                style: CustomTextStyle.smallNorText),
                             CustomText(text: widget.tripTime?.toString() ?? '0',
                           style: CustomTextStyle.tripnumbText,)
                          ],
                        ): 
                        Column(
                          children: [
                            CustomText(
                                text: 'Trip Time',
                                style: CustomTextStyle.smallNorText),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:widget.tripTime!=null&&widget.tripTime.isNotEmpty? widget.tripTime.toString():"0",
                                    style: CustomTextStyle.tripnumbText,
                                  ),
                                  TextSpan(
                                    text: ' mins',
                                    style: CustomTextStyle
                                        .tripnumbText, // You can use a different style here if needed
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            CustomText(
                                text: 'Total KM',
                                style: CustomTextStyle.smallNorText),
                            CustomText(
                              text: widget.tripKm.toString(),
                              style: CustomTextStyle.tripnumbText,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            CustomText(text: 'Rating'),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                CustomText(
                                  text: widget.rating.toString(),
                                  style: CustomTextStyle.tripnumbText,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}

String formatDate({required String dateStr}) {
  DateTime dateTime = DateTime.parse(dateStr);
  dateTime = dateTime.add(Duration(hours: 5, minutes: 30));
  String formattedDate =
      DateFormat("h:mm a").format(dateTime).toUpperCase();
  return formattedDate;
}

String formattedDate({required String dateStr}) {
  DateTime dateTime = DateTime.parse(dateStr);
  dateTime = dateTime.add(Duration(hours: 5, minutes: 30));
  String formattedDate =
      DateFormat("d MMM yyyy").format(dateTime);
  return formattedDate;
}
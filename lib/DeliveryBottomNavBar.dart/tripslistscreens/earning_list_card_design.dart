import 'package:dotted_line/dotted_line.dart';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EarningListCarddesign extends StatefulWidget {
  final dynamic dataList;
  final int index;
  const EarningListCarddesign({super.key, required this.index, this.dataList});

  @override
  State<EarningListCarddesign> createState() => _EarningListCarddesignState();
}

class _EarningListCarddesignState extends State<EarningListCarddesign> {
  String formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '';
    try {
      final parsedDate = DateTime.parse(dateTime.toString()).toUtc().toLocal();
      return DateFormat('dd-MM-yyyy hh:mm a').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Customcolors.deepdecorationLightGrey,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    ConstContentService().deliveryTypeMethod(widget
                        .dataList[widget.index]["tripDetails"]["type"]
                        .toString()),
                    style: CustomTextStyle.blackboldMediumText),
                Text(
                    'Order ID : #${widget.dataList[widget.index]["orderDetails"]["orderCode"].toString()}',
                    style: CustomTextStyle.orderblueAmountText),
              ],
            ),
            CustomSizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: 'From', style: CustomTextStyle.blackNormalText),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomText(
                        text: widget.dataList[widget.index]["tripDetails"]
                                ["pickupDetails"][0]["name"]
                            .toString(),
                        overflow: TextOverflow.clip,
                        style: CustomTextStyle.blackNormalText,
                      ),
                    ),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.4,
                      child: CustomText(
                        text: (widget.dataList[widget.index]["tripDetails"]
                                ["pickupDetails"][0]["fullAddress"] ??
                            ""),
                        maxLines: 3,
                        style: CustomTextStyle.smallGreyTAddressext,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: 'To', style: CustomTextStyle.blackNormalText),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomText(
                        text: capitalizeFirstLetter(
                          widget.dataList[widget.index]["tripDetails"]
                                  ["deliveryDetails"][0]["name"]
                              .toString(),
                        ),
                        overflow: TextOverflow.clip,
                        style: CustomTextStyle.blackNormalText,
                      ),
                    ),
                    CustomSizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.4,
                      child: CustomText(
                          maxLines: 3,
                          text: widget.dataList[widget.index]["tripDetails"]
                                  ["deliveryDetails"][0]["fullAddress"] ??
                              "",
                          style: CustomTextStyle.smallGreyTAddressext),
                    ),
                  ],
                ),
                // CustomText(
                //   text: dataList[index]["orderDetails"]["deliveryType"].toString(),
                //   style: CustomTextStyle.redSmallText,
                // ),
              ],
            ),
            CustomSizedBox(height: 20),
            DottedLine(),
            CustomSizedBox(height: 15),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       children: [
            //         CustomContainer(
            //           height: 30,
            //           borderRadius: BorderRadius.circular(10),
            //           backgroundColor: Customcolors.eEstdecorationGreen,
            //           child: Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 CustomText(
            //                     text: 'Est.Cost: ₹',
            //                     style: CustomTextStyle.esttext),
            //                 CustomText(
            //                     text: ConstContentService().stringToDouble(
            //                         dataList[index]["orderDetails"]
            //                                 ["amountDetails"]["finalAmount"]
            //                             .toString()),
            //                     style: CustomTextStyle.esttext),
            //               ],
            //             ),
            //           ),
            //         ),
            //         SizedBox(width: 10),
            //         CustomContainer(
            //           height: 30,
            //           // width:
            //           //     MediaQuery.of(context).size.width / 3.8,
            //           borderRadius: BorderRadius.circular(10),
            //           backgroundColor:  Color(0xFFFFF9E6),
            //           child: Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 CustomText(
            //                     text: 'Distance:',
            //                     style: CustomTextStyle.distancetext),
            //                 CustomText(
            //                     text:
            //                         '${dataList[index]["orderDetails"]["totalKms"].toString()} km',
            //                     style: CustomTextStyle.distancetext),
            //               ],
            //             ),
            //           ),
            //         ),
            //         SizedBox(width: 10),
            //         CustomContainer(
            //           height: 30,
            //           borderRadius: BorderRadius.circular(10),
            //           backgroundColor: Color(0xFFE6F5FE),
            //           child: Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 // CustomText(
            //                 //     text:
            //                 //         'Time: ${ConstContentService().kmToTime(dataList[index]["orderDetails"]["totalKms"].toString())}',
            //                 //     style: CustomTextStyle.smallBlueText),
            //                dataList[index]["tripDetails"]["tripTime"]!=null&&dataList[index]["tripDetails"]["tripTime"].isNotEmpty?
            //                CustomText(
            //                     text:
            //                         'Time: ${dataList[index]["tripDetails"]["tripTime"].toString()}',
            //                     style: CustomTextStyle.timeBlueText):CustomText(
            //                     text:
            //                         'Time: 0',
            //                     style: CustomTextStyle.timeBlueText),
            //                 CustomText(
            //                     text: ' mins',
            //                     style: CustomTextStyle.timeBlueText),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Icon(MdiIcons.chevronRight),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        widget.dataList[widget.index]["orderDetails"]
                                    ["paymentMethod"] ==
                                "ONLINE"
                            ? buildInfoTag(
                                label: ' ',
                                value: "Online Payment",
                                style: TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                                bgColor:   Colors.green,
                              )
                            : buildInfoTag(
                                label: ' ',
                                value: "COD",
                                style: TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                                 bgColor:   Colors.green,
                              ),
                        const SizedBox(width: 10),
                        buildInfoTag(
                          label: 'Distance:',
                          value:
                              '${widget.dataList[widget.index]["orderDetails"]["totalKms"]} km',
                      style: TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                           bgColor: const Color.fromARGB(255, 240, 212, 128)
                        ),
                        const SizedBox(width: 10),
                        buildInfoTag(
                          label: '',
                          value: formatDateTime(widget.dataList[widget.index]
                                  ["tripDetails"]["deliveredAt"]
                              .toString()),
                        style:TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontFamily: 'Poppins-Medium'),
                          bgColor: const Color.fromARGB(255, 218, 78, 104)
                        ),
                        const SizedBox(width: 10),
                        buildInfoTag(
                          label: 'Time:',
                          value:
                              '${widget.dataList[widget.index]["tripDetails"]["tripTime"] != null && widget.dataList[widget.index]["tripDetails"]["tripTime"].toString().isNotEmpty ? widget.dataList[widget.index]["tripDetails"]["tripTime"] : double.parse(widget.dataList[widget.index]["orderDetails"]["totalKms"].toString()) * 4} mins',
                          style: CustomTextStyle.timeBlueText,
                          bgColor: const Color.fromARGB(255, 193, 218, 233),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(MdiIcons.chevronRight),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buildInfoTag({
  required String label,
  required String value,
  required TextStyle style,
  required Color bgColor,
}) {
  return CustomContainer(
    height: 30,
    borderRadius: BorderRadius.circular(10),
    backgroundColor: bgColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: label, style: style),
          CustomText(text: value, style: style),
        ],
      ),
    ),
  );
}

// ignore_for_file: avoid_print

import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/deposite_update_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/provider/deposite_pagin_provider.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/transactiondetailsscreen.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class DepositeTransPagin extends StatefulWidget {
  const DepositeTransPagin({super.key});

  @override
  State<DepositeTransPagin> createState() => _DepositeTransPaginState();
}

class _DepositeTransPaginState extends State<DepositeTransPagin> {
  String stdd = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String endd = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int i = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        i = 0;
      });

      Provider.of<DepositProviderPagin>(context, listen: false)
          .clearData()
          .then((value) {
        Provider.of<DepositProviderPagin>(context, listen: false)
            .fetchEarningData(startdate: stdd, endDate: endd);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var earningsProvider = Provider.of<DepositProviderPagin>(context);

    return Scaffold(
      backgroundColor: Customcolors.decorationbackground,
      appBar: AppBar(
        backgroundColor: Customcolors.decorationbackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade600,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: CustomText(
          text: 'Deposit',
          style: CustomTextStyle.screenTitle,
        ),
      ),
      body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          print('Scroll started');
        } else if (notification is ScrollUpdateNotification) {
          print('Scrolling in progress');
        } else if (notification is ScrollEndNotification) {
          if (earningsProvider.totalCount != null &&
              earningsProvider.fetchCount != null &&
              earningsProvider.fetchedDatas.length !=
                  earningsProvider.totalCount) {
            setState(() {
              i = i + 1;
            });

            Provider.of<DepositProviderPagin>(context, listen: false)
                .fetchEarningData(endDate: endd, offset: i, startdate: stdd);

            print(
                'No more data to fetch in If Part ${earningsProvider.totalCount}  ${earningsProvider.fetchCount}');
          } else {
            print(
                'No more data to fetch  ${earningsProvider.totalCount}  ${earningsProvider.fetchCount}');
          }

          print('Scroll ended $i');
        }
        return true;
      }, child: Consumer<DepositProviderPagin>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(
                child: Column(
              children: [
                depositeRequestMethod(true),
                CupertinoActivityIndicator(),
              ],
            ));
          } else if (value.fetchedDatas.isEmpty) {
            return emptyContainerdesign(context);
          } else {
            return ListView.builder(
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              itemCount: value.moreDataLoading
                  ? value.fetchedDatas.length + 2
                  : value.fetchedDatas.length + 1,
              itemBuilder: (context, index) {
                if (index - 1 >= value.fetchedDatas.length) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoActivityIndicator(),
                  ));
                }
                //  String formattedDate =
                // DateFormat('dd MMMM, yyyy | hh:mm a')
                //     .format(value.fetchedDatas[index]["createdAt"]);
                if (index == 0) {
                  return depositeRequestMethod(false);
                }
                return InkWell(
                  onTap: () {
                    if (value.fetchedDatas[index - 1]["depositStatus"]
                            .toString() ==
                        "request") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DepositeUpdateScreen(
                                    data: value.fetchedDatas,
                                    index: index - 1,
                                  )));
                    } else if (value.fetchedDatas[index - 1]["depositStatus"]
                            .toString() ==
                        "failed") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DepositeUpdateScreen(
                                    data: value.fetchedDatas,
                                    index: index - 1,
                                  )));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetails(
                            transactionDetails: value.fetchedDatas[index - 1],
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Customcolors.decorationpureWhite,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Order Details:",
                                style: CustomTextStyle.stepTitleText,
                              ),
                              SizedBox(height: 5),
                              CustomText(
                                text:
                                    "Total Orders: ${value.fetchedDatas[index - 1]["orderDetails"].length.toString()}",
                                style: CustomTextStyle.mobilelabelText,
                              ),
                              CustomText(
                                text:
                                    "Trip Amount: ${value.fetchedDatas[index - 1]["amountDetails"]["tips"].toString() == "null" ? 0 : value.fetchedDatas[index - 1]["amountDetails"]["tips"].toString()}",
                                style: CustomTextStyle.mobilelabelText,
                              ),
                              CustomText(
                                text:
                                    "Deposit No: ${value.fetchedDatas[index - 1]["depositNo"].toString()}",
                                style: CustomTextStyle.mobilelabelText,
                              ),
                            ],
                          ),
                        ),

                        //  Spacer(),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: value.fetchedDatas[index - 1]
                                              ["depositStatus"] ==
                                          "request"
                                      ? 'In Request'
                                      : getPaymentTypeLabel(
                                          value.fetchedDatas[index - 1]
                                              ["paymentType"]),
                                  style: CustomTextStyle.stepTitleText,
                                ),
                                CustomText(
                                  text: TimerService().formatDate(
                                      dateStr: value.fetchedDatas[index - 1]
                                              ["createdAt"]
                                          .toString()),
                                  style: CustomTextStyle.chipgrey,
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text:
                                      '₹ ${value.fetchedDatas[index - 1]["amountDetails"]["offlineAmount"].toStringAsFixed(2)}',
                                  style: CustomTextStyle.blackboldSmallText,
                                ),
                                CustomText(
                                  text: value.fetchedDatas[index - 1]
                                          ["depositStatus"]
                                      .toString()
                                      .capitalizeFirst
                                      .toString(),
                                  style: getDepositStatusStyle(
                                      value.fetchedDatas[index - 1]
                                          ["depositStatus"]),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Icon(MdiIcons.chevronRight),
                          ],
                        ),
                      ],
                    ),
                  ),
                );

                // return CustomText(text: "data loaded");
              },
            );
          }
        },
      )),
    );
  }

  Center emptyContainerdesign(BuildContext context) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        depositeRequestMethod(false),
        SizedBox(height: MediaQuery.of(context).size.height / 8),
        //CustomText(text: '', style: CustomTextStyle.noEarnings),
        SizedBox(height: 10),
        CustomText(
          text: 'There is no deposit amount associated with this transaction.',
          style: CustomTextStyle.screenTitle,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }

  String getPaymentTypeLabel(dynamic paymentType) {
    final type = paymentType?.toString();

    if (type == "others") return "Cash Payment";
    if (type == "UPI") return "UPI Payment";
    if (type == "bankTransfer") return "Bank Transfer";
    return "Unknown";
  }

  TextStyle getDepositStatusStyle(String status) {
    switch (status) {
      case "deposited":
        return CustomTextStyle.greenText;
      case "pending":
        return CustomTextStyle.blue13Text;
      case "failed":
      case "request":
        return CustomTextStyle.redSmallText;
      default:
        return CustomTextStyle.blacktext; // fallback style
    }
  }

  SizedBox depositeRequestMethod(bool isDataUpdate) {
    return SizedBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DepositScreen(isdataUpdate: isDataUpdate,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: CustomText(
            text: 'Transaction History',
            style: CustomTextStyle.stepTitleText,
          ),
        ),
      ],
    ));
  }
}

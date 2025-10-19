// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:miogra_service/Shimmer/notificationshimmer.dart';
import 'package:http/http.dart' as http;
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/Model.dart/Notification/notificationmodel.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;

  final PagingController<int, Datum> pagingController =
      PagingController(firstPageKey: 0);
  final int defaultPageSize = 10;
  String usertoken = getStorage.read("Usertoken") ?? '';
  String userId = getStorage.read("UserId") ?? '';

  final List<Datum> notifications = [];

  @override
  void initState() {
    super.initState();

    pagingController.addPageRequestListener((page) {
      getNotifications(page, defaultPageSize);
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> getNotifications(int page, int perPage) async {
    try {
      final uri = Uri.parse(
        '${API.notificationsApi}'
        '?limit=$perPage&offset=$page'
        '&displayType=deliveryman&parentAdminUserId=$parentAdminId',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $usertoken',
          'Content-Type': 'application/json',
          'userId': userId,
        },
      );

      // 1️⃣  BAD STATUS  →  tell the controller it failed
      if (response.statusCode != 200) {
        print(uri);
        pagingController.error =
            HttpException('Server returned ${response.statusCode}');
        return; // ▸ Skip the rest
      }

      // 2️⃣  GOOD STATUS  →  decode & append
      final decoded = jsonDecode(response.body);
      final model = GetNotificationModel.fromJson(decoded);

      if (model.data.data.isEmpty) {
        pagingController.appendLastPage([]); // empty page
      } else {
        pagingController.appendPage(model.data.data, page + 1);
      }
    } catch (e) {
      pagingController.error = e; // network / parse error
    } finally {}
  }

  // Future<void> getNotifications(int page, int perPage) async {
  //   try {
  //     final response = await http.get(
  //         Uri.parse(
  //             '${API.notificationsApi}?limit=$perPage&offset=$page&customerId=$userId&displayType=deliveryman'),
  //         headers: {
  //           'Authorization': 'Bearer $usertoken',
  //           'Content-Type': 'application/json',
  //           'userId': userId,
  //         });

  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       final data = GetNotificationModel.fromJson(result);

  //       // Print debug info for received notifications

  //       final totalItems = data.data.data.length;

  //       if (totalItems == 0) {
  //         pagingController.appendLastPage([]);
  //       } else {
  //         pagingController.appendPage(data.data.data, page + 1);
  //       }
  //     } else {
  //       pagingController.error = "No more data";
  //     }
  //   } catch (e) {
  //     pagingController.error = e;
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<bool> _onWillPop() async {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               DeliveryBottomNavigation(showBottomSheet: false)));
  //   return false;
  // }

  String _formatTime(String dateTime) {
    if (dateTime.isEmpty) {
      return "N/A"; // Return a default value if the date is invalid or empty
    }

    try {
      final date =
          DateTime.parse(dateTime).add(Duration(hours: 5, minutes: 30));
      final time = TimeOfDay.fromDateTime(date);
      return time.format(context);
    } catch (e) {
      return "Invalid date"; // Handle parsing error
    }
  }

  String _getNotificationCategory(DateTime notificationDate) {
    final now = DateTime.now();
    
    final today =
        DateTime(now.year, now.month, now.day); // Today's date without time
    final yesterday =
        today.subtract(Duration(days: 1)); // Yesterday's date without time

    final notificationDateOnly = DateTime(
        notificationDate.year, notificationDate.month, notificationDate.day);

    if (notificationDateOnly == today) {
      return 'Recent'; // Notification is from today
    } else if (notificationDateOnly == yesterday) {
      return 'Yesterday'; // Notification is from yesterday
    } else {
      return 'Earlier'; // Notification is older than yesterday
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryBottomNavigation(showBottomSheet: false)));
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DeliveryBottomNavigation(showBottomSheet: false))),
            ),
            title: Center(
              child: CustomText(
                text: 'Notifications         ',
                style: CustomTextStyle.screenTitle,
              ),
            ),
          ),
          body: PagedListView<int, Datum>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<Datum>(
              itemBuilder: (context, item, index) {
                DateTime createdAt =
                    DateTime.tryParse(item.createdAt?.toString() ?? '') ??
                        DateTime.now();
                final category = _getNotificationCategory(createdAt);

                // Determine if the category header should be shown
                final showCategoryHeader = index == 0 ||
                    _getNotificationCategory(DateTime.tryParse(pagingController
                                    .itemList![index - 1].createdAt
                                    ?.toString() ??
                                '') ??
                            DateTime.now()) !=
                        category;

                // return Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       if (showCategoryHeader)
                //         CustomText(
                //           text: category,
                //           style: CustomTextStyle.mediumGreyText,
                //         ),
                //       CustomSizedBox(height: 20),
                //       _buildNotificationItem(item),
                //     ],
                //   ),
                // );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showCategoryHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: CustomText(
                          text: category,
                          style: CustomTextStyle.mediumGreyText,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: _buildNotificationItem(item),
                    ),
                  ],
                );
              },

              //------------------------------------------------------------------
              // STATES
              //------------------------------------------------------------------
              firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: NotificationShimmer()), // always shimmer

              newPageProgressIndicatorBuilder: (_) =>
                  const Center(child: CircularProgressIndicator()),

              firstPageErrorIndicatorBuilder: (_) => Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Image.asset('assets/images/nonotifications.png'),
                ),
              ),

              newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),

              noItemsFoundIndicatorBuilder: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_outline,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    CustomText(
                      text: 'No messages',
                      style: CustomTextStyle.mediumGreyText,
                    ),
                  ],
                ),
              ),

              noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
            ),
          )

          //  PagedListView<int, Datum>(
          //     pagingController: pagingController,
          //     builderDelegate: PagedChildBuilderDelegate<Datum>(
          //       itemBuilder: (context, item, index) {
          //         DateTime createdAt =
          //             DateTime.tryParse(item.createdAt?.toString() ?? '') ??
          //                 DateTime.now();
          //         final category = _getNotificationCategory(createdAt);

          //         // Determine if the category header should be shown
          //         final showCategoryHeader = index == 0 ||
          //             _getNotificationCategory(DateTime.tryParse(pagingController
          //                             .itemList![index - 1].createdAt
          //                             ?.toString() ??
          //                         '') ??
          //                     DateTime.now()) !=
          //                 category;

          //         // return Padding(
          //         //   padding: const EdgeInsets.all(12.0),
          //         //   child: Column(
          //         //     crossAxisAlignment: CrossAxisAlignment.start,
          //         //     children: [
          //         //       if (showCategoryHeader)
          //         //         CustomText(
          //         //           text: category,
          //         //           style: CustomTextStyle.mediumGreyText,
          //         //         ),
          //         //       CustomSizedBox(height: 20),
          //         //       _buildNotificationItem(item),
          //         //     ],
          //         //   ),
          //         // );
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             if (showCategoryHeader)
          //               Padding(
          //                 padding: const EdgeInsets.symmetric(
          //                     vertical: 8.0, horizontal: 12.0),
          //                 child: CustomText(
          //                   text: category,
          //                   style: CustomTextStyle.mediumGreyText,
          //                 ),
          //               ),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //               child: _buildNotificationItem(item),
          //             ),
          //           ],
          //         );
          //       },
          //       firstPageProgressIndicatorBuilder: (_) => isLoading
          //           ? const Center(child: NotificationShimmer())
          //           : Container(color: Colors.blue),
          //       newPageProgressIndicatorBuilder: (_) => Container(),
          //       noItemsFoundIndicatorBuilder: (_) => Center(
          //         child: CircularProgressIndicator(color: Colors.yellow),
          //       ),
          //       firstPageErrorIndicatorBuilder: (_) => Center(
          //         child: SizedBox(
          //             height: MediaQuery.of(context).size.height / 3,
          //             width: MediaQuery.of(context).size.width / 1.5,
          //             child: Image.asset('assets/images/nonotifications.png')),
          //       ),
          //       newPageErrorIndicatorBuilder: (_) => SizedBox.shrink(),
          //       noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
          //     )),,
          ),
    );
  }

  Widget _buildNotificationItem(Datum notification) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16), // spacing between items
      padding: const EdgeInsets.all(12), // internal content padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: notification.title ?? 'No title',
                  style: CustomTextStyle.stepTitleText,
                ),
              ),
              SizedBox(width: 8),
              CustomText(
                text: _formatTime(notification.createdAt?.toString() ?? ''),
                style: CustomTextStyle.notiTimeGreyText,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: notification.body ?? 'No message',
            style: CustomTextStyle.identityGreyText,
          ),
        ],
      ),
    );
  }
}

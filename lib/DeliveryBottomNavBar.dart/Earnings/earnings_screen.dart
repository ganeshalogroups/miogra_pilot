// // ignore_for_file: unused_field, avoid_print

// import 'dart:async';
// import 'dart:convert';
// import 'package:miogra_service/Const.dart/const_colors.dart';
// import 'package:miogra_service/Const.dart/const_content_service.dart';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/Controller.dart/EarningsController/chartcontroller.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/chartscreen.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/earningcountscreen.dart';
// import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
// import 'package:miogra_service/UrlList.dart/api.dart';
// import 'package:miogra_service/widgets.dart/custom_calendor.dart';
// import 'package:miogra_service/widgets.dart/custom_trips.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
// import '../../widgets.dart/custom_text.dart';
// import '../../widgets.dart/custom_textstyle.dart';
// import 'package:http/http.dart' as http;
// import 'tripdetailsscreen.dart';
// import 'package:table_calendar/table_calendar.dart';

// class EarningsScreen extends StatefulWidget {
//   const EarningsScreen({super.key});

//   @override
//   State<EarningsScreen> createState() => _EarningsScreenState();
// }

// Logger logg = Logger();

// class _EarningsScreenState extends State<EarningsScreen> {
//   final ToggleBtnController toggleController = Get.put(ToggleBtnController());
//   final ScrollController _scrollController = ScrollController();

//   String stdd = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   String endd = DateFormat('yyyy-MM-dd').format(DateTime.now());

//   late DateTime _selectedMonth = DateTime.now();

//   late DateTime _selectedWeekStartDate = DateTime.now();
//   late DateTime _selectedWeekEndDate = DateTime.now();
//   late DateTime _onMonthSelected = DateTime.now();

//   bool _isMonthView = true;
//   bool _isMonth = false;

//   int pageOffset = 0; // Changed variable name for clarity

//   final ChartController chartController = ChartController();
//   Timer? debounce;

//   bool showAvg = false;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         i = 0;
//       });

//       Provider.of<EarningPaginations>(context, listen: false)
//           .clearData()
//           .then((value) {
//         Provider.of<EarningPaginations>(context, listen: false)
//             .fetchEarningData(startdate: stdd, endDate: endd);
//       });
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   final Set<DateTime> _selectedDates = {};

//   void _showCustomDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//               color: Colors.white,
//             ),
//             width: 300, // Width of the dialog
//             height: 500, // Height of the dialog
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Expanded(
//                   child: DefaultTabController(
//                     length: 2,
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         Container(
//                           decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5)),
//                               color: Colors.white),
//                           child: TabBar(
//                             indicatorColor: Customcolors.darkPurple,
//                             labelColor:
//                                 Colors.black, // Color of the active tab text
//                             unselectedLabelColor:
//                                 Colors.grey, // Color of the inactive tab text

//                             tabs: const [
//                               Tab(text: 'Select Date'),
//                               Tab(text: 'Customize'),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: TabBarView(
//                             children: [
//                               Column(
//                                 children: [
//                                   MultiDateCalendar(),
//                                   TextButton(
//                                     onPressed: () {
//                                       final start = rangeStart;
//                                       final end = rangeEnd ?? rangeStart;

//                                       if (start == null) return;

//                                       print(start);
//                                       print(end);

//                                       setState(() {
//                                         stdd = DateFormat('yyyy-MM-dd')
//                                             .format(start);
//                                         endd = DateFormat('yyyy-MM-dd')
//                                             .format(end!);

//                                         _selectedMonth = start;
//                                         _isMonth = false;
//                                         _isMonthView = true;
//                                         _selectedWeekStartDate = start;
//                                         _selectedWeekEndDate = end;
//                                         i = 0;
//                                       });

//                                       Provider.of<EarningPaginations>(context,
//                                               listen: false)
//                                           .clearData()
//                                           .then((value) {
//                                         Provider.of<EarningPaginations>(context,
//                                                 listen: false)
//                                             .fetchEarningData(
//                                                 endDate: endd, startdate: stdd);
//                                       });

//                                       Navigator.of(context).pop();

//                                       // Clear range values
//                                       rangeStart = null;
//                                       rangeEnd = null;
//                                     },
//                                     child: Text(
//                                       "Done",
//                                       style: CustomTextStyle.blackNormalText,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               CustomCalendar(
//                                 onMonthSelected: (selectedMonth) {
//                                   setState(() {
//                                     _onMonthSelected = selectedMonth;
//                                     _selectedMonth = selectedMonth;
//                                     _isMonth = true;
//                                     DateTime firstDayOfMonth = DateTime(
//                                         selectedMonth.year,
//                                         selectedMonth.month,
//                                         1);
//                                     DateTime lastDayOfMonth = DateTime(
//                                         selectedMonth.year,
//                                         selectedMonth.month + 1,
//                                         0);

//                                     stdd = DateFormat('yyyy-MM-dd')
//                                         .format(firstDayOfMonth);
//                                     endd = DateFormat('yyyy-MM-dd')
//                                         .format(lastDayOfMonth);
//                                     i = 0;
//                                   });

//                                   Provider.of<EarningPaginations>(context,
//                                           listen: false)
//                                       .clearData()
//                                       .then((value) {
//                                     Provider.of<EarningPaginations>(context,
//                                             listen: false)
//                                         .fetchEarningData(
//                                             endDate: endd, startdate: stdd);
//                                   });

//                                   Navigator.of(context).pop();
//                                 },
//                                 initialWeekStartDate: _selectedWeekStartDate,
//                                 initialWeekEndDate: _selectedWeekEndDate,
//                                 onWeekSelected: (startDate, endDate) {
//                                   setState(() {
//                                     _selectedWeekStartDate = startDate;
//                                     _selectedWeekEndDate = endDate;
//                                     _isMonthView = false;
//                                     _isMonth = false;

//                                     stdd = DateFormat('yyyy-MM-dd')
//                                         .format(startDate);
//                                     endd = DateFormat('yyyy-MM-dd')
//                                         .format(endDate);
//                                     i = 0;
//                                   });

//                                   Provider.of<EarningPaginations>(context,
//                                           listen: false)
//                                       .clearData()
//                                       .then((value) {
//                                     Provider.of<EarningPaginations>(context,
//                                             listen: false)
//                                         .fetchEarningData(
//                                             endDate: endd, startdate: stdd);
//                                   });

//                                   Navigator.of(context).pop();
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _getFormattedMonth(DateTime dateTime) {
//     return DateFormat('MMMM yyyy').format(dateTime); // Example: "August 2024"
//   }

//   String _getFormattedDate(DateTime dateTime) {
//     return DateFormat('dd MMMM, yyyy').format(dateTime);
//   }

//   String _getFormattedWeek(DateTime dateTime) {
//     return DateFormat('dd MMMM').format(dateTime);
//   }

//   bool _isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var tripProvider = Provider.of<TripController>(context);

//     var earningsProvider = Provider.of<EarningPaginations>(context);

//     return PopScope(
//       canPop: false,
//       onPopInvoked: (bool didPop) async {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     DeliveryBottomNavigation(showBottomSheet: false)));
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
//             onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         DeliveryBottomNavigation(showBottomSheet: false))),
//           ),
//           title: CustomText(
//             text: 'Earnings',
//             style: CustomTextStyle.screenTitle,
//           ),
//         ),
//         body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       _showCustomDialog(context);
//                     },
//                     child: CustomText(
//                       text: _isMonth
//                           ? _getFormattedMonth(_selectedMonth)
//                           : (_selectedWeekStartDate != null &&
//                                   _selectedWeekEndDate != null &&
//                                   !_isSameDay(_selectedWeekStartDate,
//                                       _selectedWeekEndDate))
//                               ? '${_getFormattedWeek(_selectedWeekStartDate)} - ${_getFormattedWeek(_selectedWeekEndDate)}'
//                               : _getFormattedDate(_selectedWeekStartDate),
//                       style: CustomTextStyle.monthBlackText,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _showCustomDialog(context);
//                     },
//                     child: SizedBox(
//                         height: 27,
//                         width: 27,
//                         child: Image.asset('assets/images/calendor.png')),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               InkWell(
//                 onTap: () {
//                   // Provider.of<EarningPaginations>(context, listen: false)
//                   //     .fetchEarningData(startdate: stdd, endDate: endd);
//                 },
//                 child: CustomText(
//                   text: _isMonth
//                       ? 'Performance For Month'
//                       : _isMonthView
//                           ? 'Performance for a day'
//                           : 'Performance For Week',
//                   style: CustomTextStyle.stepTitleText,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Column(children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     EarningCountScreen(
//                       totaltips: earningsProvider.totaltips == null
//                           ? '0'
//                           : earningsProvider.totaltips.toStringAsFixed(2),
//                       totaldeliverycharge: earningsProvider.deliverycharge ==
//                               null
//                           ? '0'
//                           : earningsProvider.deliverycharge.toStringAsFixed(2),
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 )
//               ]),
//               ChartScreen(),
//               Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: CustomText(
//                       text: 'Trips', style: CustomTextStyle.itemsText)),
//               Expanded(
//                 child: NotificationListener<ScrollNotification>(
//                     onNotification: (ScrollNotification notification) {
//                   if (notification is ScrollStartNotification) {
//                     print('Scroll started');
//                   } else if (notification is ScrollUpdateNotification) {
//                     print('Scrolling in progress');
//                   } else if (notification is ScrollEndNotification) {
//                     if (earningsProvider.totalCount != null &&
//                         earningsProvider.fetchCount != null &&
//                         earningsProvider.fetchedDatas.length !=
//                             earningsProvider.totalCount) {
//                       setState(() {
//                         i = i + 1;
//                       });

//                       Provider.of<EarningPaginations>(context, listen: false)
//                           .fetchEarningData(
//                               endDate: endd, offset: i, startdate: stdd);

//                       print(
//                           'No more data to fetch in If Part ${earningsProvider.totalCount}  ${earningsProvider.fetchCount}');
//                     } else {
//                       print(
//                           'No more data to fetch  ${earningsProvider.totalCount}  ${earningsProvider.fetchCount}');
//                     }

//                     print('Scroll ended $i');
//                   }
//                   return true;
//                 }, child: Consumer<EarningPaginations>(
//                   builder: (context, value, child) {
//                     if (value.isLoading) {
//                       return Center(child: CupertinoActivityIndicator());
//                     } else if
//                      (value.fetchedDatas.isEmpty) {
//                       return Center(
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height / 8),
//                               CustomText(
//                                   text: 'No Earnings',
//                                   style: CustomTextStyle.noEarnings),
//                               SizedBox(height: 10),
//                               CustomText(
//                                 text: 'You haven\'t completed any orders yet.',
//                                 style: CustomTextStyle.screenTitle,
//                                 textAlign: TextAlign.center,
//                               )
//                             ]),
//                       );
//                     } else {
//                       return ListView.builder(
//                         itemCount: value.moreDataLoading
//                             ? value.fetchedDatas.length + 1
//                             : value.fetchedDatas.length,
//                         itemBuilder: (context, index) {
//                           if (index >= value.fetchedDatas.length) {
//                             return Center(
//                                 child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: CupertinoActivityIndicator(),
//                             ));
//                           }

//                           final tripAmount = value.fetchedDatas[index]
//                                       ['orderDetails']?['amountDetails']
//                                   ?['deliveryCharges'] ??
//                               0;
//                           final tripKm = value.fetchedDatas[index]
//                                   ['orderDetails']?['totalKms'] ??
//                               'N/A';
//                           final orderType = value.fetchedDatas[index]
//                                   ['orderDetails']?['subAdminType'] ??
//                               'N/A';
//                           var createdAtString = value.fetchedDatas[index]
//                                   ['deliveredAtSort'] ??
//                               '';

//                           // DateTime createdAt;

//                           // try {
//                           //   if (createdAtString.isNotEmpty &&
//                           //       createdAtString.length >= 10) {
//                           //     createdAt = DateTime.parse(createdAtString);
//                           //   } else {
//                           //     createdAt = DateTime.now();
//                           //   }
//                           // } catch (e) {
//                           //   createdAt = DateTime.now();
//                           // }

//                           final ratingList =
//                               (value.fetchedDatas[index]['orderDetails']?['rating']?.isNotEmpty ?? false)
//                                   ? (value.fetchedDatas[index]['orderDetails']
//                                           ['rating'][0]['rating'] is String
//                                       ? double.tryParse(value.fetchedDatas[index]
//                                                   ['orderDetails']['rating'][0]
//                                               ['rating']) ??
//                                           0.0
//                                       : value.fetchedDatas[index]
//                                                   ['orderDetails']['rating'][0]
//                                                   ['rating']
//                                               ?.toDouble() ??
//                                           0.0)
//                                   : 0.0;

//                           int tripTimeInMinutes = (tripKm * 5).toInt();
//                           final triptime = value.fetchedDatas[index]
//                               ['tripDetails']['tripTime'];

//                           return GestureDetector(
//                             onTap: () {
//                               Get.to(
//                                   TripDetailsScreen(
//                                       earnings: value.fetchedDatas[index]),
//                                   transition: Transition.fadeIn);
//                             },
//                             child: CustomTrips(
//                               isfromTransactionDetails: false,
//                               itemCount: 1,
//                               deliverytext: ConstContentService()
//                                   .deliveryTypeMethod(orderType.toString()),
//                               orderId: value.fetchedDatas[index]['orderDetails']
//                                           ?['orderCode']
//                                       ?.toString() ??
//                                   '',
//                               dateText: createdAtString,
//                               timeText: createdAtString,
//                               tripAmount: tripAmount ?? '',
//                               tripTime: triptime,
//                               tripKm: tripKm ?? '',
//                               rating: ratingList.toString(),
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   },
//                 )),
//               )
//             ])),
//       ),
//     );
//   }

//   int i = 0; // dont play with this line
// }

// class EarningPaginations with ChangeNotifier {
//   bool isLoading = false;

//   bool moreDataLoading = false;

//   int limit = 5;
//   List fetchedDatas = [];

//   dynamic totalCount;
//   dynamic fetchCount;
//   double deliverycharge = 0.0;
//   double totaltips = 0.0;

//   Future<void> clearData() async {
//     fetchedDatas.clear();
//     totalCount = 0;
//     fetchCount = 0;
//     deliverycharge = 0.00;
//     totaltips = 0.00;
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> fetchEarningData({startdate, endDate, int offset = 0}) async {
//     try {
//       print("jsbjh shhs");
//       moreDataLoading = true;
//       notifyListeners();

//       if (offset == 0) {
//         isLoading = true;
//         notifyListeners();
//       }

//       var response = await http.get(
//         Uri.parse(
//            '${API.earningsApi}acceptedById=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&tripStatus=delivered'),
//             //'${API.earnings}deliverymanId=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&tripStatus=delivered'),
//         headers: {
//           'Authorization': 'Bearer $Usertoken',
//           'Content-Type': 'application/json',
//           'userId': UserId,
//         },
//       );
//       print(
//           'earningsapi${API.earningsApi}acceptedById=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&tripStatus=delivered');
//          // 'earningsapi${API.earnings}deliverymanId=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate');
//       print(response.statusCode);
//       print(response.body);

//       if (response.statusCode == 200) {
//         var result = jsonDecode(response.body);

//         totalCount = result['data']['totalCount'];
//         fetchCount = result['data']['fetchCount'];
//         // 👇 Only update tips and delivery charge when fetching the first page
//         if (offset == 0) {
//           deliverycharge =
//               (result['data']['totalAmountForUser'] ?? 0).toDouble();
//           totaltips = (result['data']['totalAmountForTip'] ?? 0).toDouble();
//         }
//         // deliverycharge = (result['data']['totalAmountForUser'] ?? 0).toDouble();
//         // totaltips = (result['data']['totalAmountForTip'] ?? 0).toDouble();

//         fetchedDatas.addAll(result['data']['data']);
//         notifyListeners();
       
//         if (fetchedDatas.isNotEmpty) {
//           isLoading = false;
//           notifyListeners();
//         }

//         print(response.request);
//         print('Total Length ... is ..');
//         logg.i(result['data']['data'].length);

//         for (int i = 0; i < fetchedDatas.length; i++) {
//           print(
//               '${fetchedDatas[i]['_id']}  === = =>> $totalCount  $fetchCount');
//         }
//       } else {
//         if (fetchedDatas.isEmpty) {
//           isLoading = false;
//           notifyListeners();
//         }

//         logg.i('${response.statusCode} ====<<status code issue>>');
//       }
//     } catch (e) {
//       print('Its an Exception Error $e ');
//     } finally {
//       moreDataLoading = false;
//       notifyListeners();
//     }
//   }
// }

// DateTime? rangeStart;
// DateTime? rangeEnd;

// class MultiDateCalendar extends StatefulWidget {
//   const MultiDateCalendar({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MultiDateCalendarState createState() => _MultiDateCalendarState();
// }

// class _MultiDateCalendarState extends State<MultiDateCalendar> {
//   final Set<DateTime> _selectedDates = {};

//   DateTime _focusedDay = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return TableCalendar(
//       firstDay: DateTime.utc(2020, 1, 1),
//       lastDay: DateTime.utc(2030, 12, 31),
//       focusedDay: _focusedDay,
//       rangeStartDay: rangeStart,
//       rangeEndDay: rangeEnd,
//       onDaySelected: (selectedDay, focusedDay) {
//         setState(() {
//           // _selectedDay = selectedDay;
//           rangeStart = selectedDay;
//           rangeEnd = selectedDay;
//           _focusedDay = focusedDay;
//         });
//         print(rangeStart);
//         print(rangeEnd);
//       },
//       onRangeSelected: (start, end, focusedDay) {
//         setState(() {
//           rangeStart = start;
//           rangeEnd = end;
//           _focusedDay = focusedDay;
//         });
//       },
//       calendarFormat: CalendarFormat.month,
//       rangeSelectionMode: RangeSelectionMode.enforced,
//       calendarStyle: CalendarStyle(
//           markerSizeScale: 0.2,
//           markersAnchor: 0.5,
//           rangeHighlightScale: 0.2,
//           markerMargin: const EdgeInsets.symmetric(horizontal: 0.2),
//           rangeStartDecoration: BoxDecoration(
//             color: Customcolors.darkPurple,
//             shape: BoxShape.circle,
//           ),
//           rangeEndDecoration: BoxDecoration(
//             color: Customcolors.darkPurple,
//             shape: BoxShape.circle,
//           ),
//           withinRangeDecoration: BoxDecoration(
//             color: Customcolors.darkPurple,
//             shape: BoxShape.circle,
//           ),
//           rangeHighlightColor: Customcolors.decorationGreen,
//           selectedTextStyle: CustomTextStyle.blacktext),
//     );
//   }
// }





































// ignore_for_file: unused_field, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/Const.dart/const_content_service.dart';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Controller.dart/EarningsController/chartcontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/chartscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/earningcountscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/bottom_navigation_bar.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:miogra_service/widgets.dart/custom_calendor.dart';
import 'package:miogra_service/widgets.dart/custom_trips.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../widgets.dart/custom_text.dart';
import '../../widgets.dart/custom_textstyle.dart';
import 'package:http/http.dart' as http;
import 'tripdetailsscreen.dart';
import 'package:table_calendar/table_calendar.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

Logger logg = Logger();

class _EarningsScreenState extends State<EarningsScreen> {
  final ToggleBtnController toggleController = Get.put(ToggleBtnController());
  final ScrollController _scrollController = ScrollController();

  String stdd = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String endd = DateFormat('yyyy-MM-dd').format(DateTime.now());

  late DateTime _selectedMonth = DateTime.now();

  late DateTime _selectedWeekStartDate = DateTime.now();
  late DateTime _selectedWeekEndDate = DateTime.now();
  late DateTime _onMonthSelected = DateTime.now();

  bool _isMonthView = true;
  bool _isMonth = false;
  dynamic triptime ;
  int pageOffset = 0; // Changed variable name for clarity

  final ChartController chartController = ChartController();
  Timer? debounce;

  bool showAvg = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        i = 0;
      });

      // Provider.of<EarningPaginations>(context, listen: false)
      //     .clearData()
      //     .then((value) {
      //   Provider.of<EarningPaginations>(context, listen: false)
      //       .fetchEarningData(startdate: stdd, endDate: endd);
      // });
    });

      Provider.of<EarningPaginations>(context, listen: false)
          .clearData()
          .then((value) {
        Provider.of<EarningPaginations>(context, listen: false)
            .fetchEarningData(startdate: stdd, endDate: endd);
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final Set<DateTime> _selectedDates = {};

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
           // width: 350, // Width of the dialog
            height: 500, // Height of the dialog
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white),
                          child: TabBar(
                            indicatorColor: Customcolors.darkPurple,
                            labelColor:
                                Colors.black, // Color of the active tab text
                            unselectedLabelColor:
                                Colors.grey, // Color of the inactive tab text

                            tabs: const [
                              Tab(text: 'Select Date'),
                              Tab(text: 'Customize'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Column(
                                children: [
                                  MultiDateCalendar(),
                                  TextButton(
                                    onPressed: () {
                                      final start = rangeStart;
                                      final end = rangeEnd ?? rangeStart;

                                      if (start == null) return;

                                      print(start);
                                      print(end);

                                      setState(() {
                                        stdd = DateFormat('yyyy-MM-dd')
                                            .format(start);
                                        endd = DateFormat('yyyy-MM-dd')
                                            .format(end!);

                                        _selectedMonth = start;
                                        _isMonth = false;
                                        _isMonthView = true;
                                        _selectedWeekStartDate = start;
                                        _selectedWeekEndDate = end;
                                        i = 0;
                                      });

                                      Provider.of<EarningPaginations>(context,
                                              listen: false)
                                          .clearData()
                                          .then((value) {
                                        Provider.of<EarningPaginations>(context,
                                                listen: false)
                                            .fetchEarningData(
                                                endDate: endd, startdate: stdd);
                                      });

                                      Navigator.of(context).pop();

                                      // Clear range values
                                      rangeStart = null;
                                      rangeEnd = null;
                                    },
                                    child: Text(
                                      "Done",
                                      style: CustomTextStyle.blackNormalText,
                                    ),
                                  ),
                                ],
                              ),
                              CustomCalendar(
                                onMonthSelected: (selectedMonth) {
                                  setState(() {
                                    _onMonthSelected = selectedMonth;
                                    _selectedMonth = selectedMonth;
                                    _isMonth = true;
                                    DateTime firstDayOfMonth = DateTime(
                                        selectedMonth.year,
                                        selectedMonth.month,
                                        1);
                                    DateTime lastDayOfMonth = DateTime(
                                        selectedMonth.year,
                                        selectedMonth.month + 1,
                                        0);

                                    stdd = DateFormat('yyyy-MM-dd')
                                        .format(firstDayOfMonth);
                                    endd = DateFormat('yyyy-MM-dd')
                                        .format(lastDayOfMonth);
                                    i = 0;
                                  });

                                  Provider.of<EarningPaginations>(context,
                                          listen: false)
                                      .clearData()
                                      .then((value) {
                                    Provider.of<EarningPaginations>(context,
                                            listen: false)
                                        .fetchEarningData(
                                            endDate: endd, startdate: stdd);
                                  });

                                  Navigator.of(context).pop();
                                },
                                initialWeekStartDate: _selectedWeekStartDate,
                                initialWeekEndDate: _selectedWeekEndDate,
                                onWeekSelected: (startDate, endDate) {
                                  setState(() {
                                    _selectedWeekStartDate = startDate;
                                    _selectedWeekEndDate = endDate;
                                    _isMonthView = false;
                                    _isMonth = false;

                                    stdd = DateFormat('yyyy-MM-dd')
                                        .format(startDate);
                                    endd = DateFormat('yyyy-MM-dd')
                                        .format(endDate);
                                    i = 0;
                                  });

                                  Provider.of<EarningPaginations>(context,
                                          listen: false)
                                      .clearData()
                                      .then((value) {
                                    Provider.of<EarningPaginations>(context,
                                            listen: false)
                                        .fetchEarningData(
                                            endDate: endd, startdate: stdd);
                                  });

                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getFormattedMonth(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime); // Example: "August 2024"
  }

  String _getFormattedDate(DateTime dateTime) {
    return DateFormat('dd MMMM, yyyy').format(dateTime);
  }

  String _getFormattedWeek(DateTime dateTime) {
    return DateFormat('dd MMMM').format(dateTime);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    // var tripProvider = Provider.of<TripController>(context);

    var earningsProvider = Provider.of<EarningPaginations>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryBottomNavigation(showBottomSheet: false)));
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DeliveryBottomNavigation(showBottomSheet: false))),
          ),
          title: CustomText(
            text: 'Earnings',
            style: CustomTextStyle.screenTitle,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showCustomDialog(context);
                    },
                    child: CustomText(
                      text: _isMonth
                          ? _getFormattedMonth(_selectedMonth)
                          : (_selectedWeekStartDate != null &&
                                  _selectedWeekEndDate != null &&
                                  !_isSameDay(_selectedWeekStartDate,
                                      _selectedWeekEndDate))
                              ? '${_getFormattedWeek(_selectedWeekStartDate)} - ${_getFormattedWeek(_selectedWeekEndDate)}'
                              : _getFormattedDate(_selectedWeekStartDate),
                      style: CustomTextStyle.monthBlackText,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _showCustomDialog(context);
                    },
                    child: SizedBox(
                        height: 27,
                        width: 27,
                        child: Image.asset('assets/images/calendor.png')),
                  ),
                ],
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  // Provider.of<EarningPaginations>(context, listen: false)
                  //     .fetchEarningData(startdate: stdd, endDate: endd);
                },
                child: CustomText(
                  text: _isMonth
                      ? 'Performance For Month'
                      : _isMonthView
                          ? 'Performance for a day'
                          : 'Performance For Week',
                  style: CustomTextStyle.stepTitleText,
                ),
              ),
              SizedBox(height: 10),
              Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EarningCountScreen(
                      tripAmount: earningsProvider.datas,
                      totaltips: earningsProvider.totaltips == null
                          ? '0'
                          : earningsProvider.totaltips.toStringAsFixed(2),
                      totaldeliverycharge: earningsProvider.deliverycharge ==
                              null
                          ? '0'
                          : earningsProvider.deliverycharge.toStringAsFixed(2),
                    ),
                    SizedBox(height: 20),
                  ],
                )
              ]),
             // ChartScreen(tripAmount: earningsProvider.datas,),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CustomText(
                      text: 'Trips', style: CustomTextStyle.itemsText)),
              Expanded(
                child: NotificationListener<ScrollNotification>(
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

                      Provider.of<EarningPaginations>(context, listen: false)
                          .fetchEarningData(
                              endDate: endd, offset: i, startdate: stdd);

                      print(
                          'No more data to fetch in If Part ${earningsProvider.totalCount}  ${earningsProvider.fetchCount}');
                    } else {
                      print(
                          'No more data to fetch  ${earningsProvider.totalCount}  ${earningsProvider.fetchCount}');
                    }

                    print('Scroll ended $i');
                  }
                  return true;
                }, 
                child: Consumer<EarningPaginations>(
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if
                     (value.fetchedDatas.isEmpty) {
                      return Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 8),
                              CustomText(
                                  text: 'No Earnings',
                                  style: CustomTextStyle.noEarnings),
                              SizedBox(height: 10),
                              CustomText(
                                text: 'You haven\'t completed any orders yet.',
                                style: CustomTextStyle.screenTitle,
                                textAlign: TextAlign.center,
                              )
                            ]),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: value.moreDataLoading
                            ? value.fetchedDatas.length + 1
                            : value.fetchedDatas.length,
                        itemBuilder: (context, index) {
                          if (index >= value.fetchedDatas.length) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CupertinoActivityIndicator(),
                            ));
                          }

                         final  tripAmount = value.fetchedDatas[index]
                                  ["earningAmount"]??0;
                                  //     ['orderDetails']?['amountDetails']
                                  // ?['deliveryCharges'] ??
                              0;
                          final tripKm = value.fetchedDatas[index]
                                  ['orderDetails']?['totalKms'] ??
                              'N/A';
                          final orderType = value.fetchedDatas[index]
                                  ['orderDetails']?['subAdminType'] ??
                              'N/A';
                          var createdAtString = value.fetchedDatas[index]
                                  ['date'] ??
                              '';

                          // DateTime createdAt;

                          // try {
                          //   if (createdAtString.isNotEmpty &&
                          //       createdAtString.length >= 10) {
                          //     createdAt = DateTime.parse(createdAtString);
                          //   } else {
                          //     createdAt = DateTime.now();
                          //   }
                          // } catch (e) {
                          //   createdAt = DateTime.now();
                          // }

                          final ratingList =
                              (value.fetchedDatas[index]['orderDetails']?['rating']?.isNotEmpty ?? false)
                                  ? (value.fetchedDatas[index]['orderDetails']
                                          ['rating'][0]['rating'] is String
                                      ? double.tryParse(value.fetchedDatas[index]
                                                  ['orderDetails']['rating'][0]
                                              ['rating']) ??
                                          0.0
                                      : value.fetchedDatas[index]
                                                  ['orderDetails']['rating'][0]
                                                  ['rating']
                                              ?.toDouble() ??
                                          0.0)
                                  : 0.0;

                          int tripTimeInMinutes = (tripKm * 5).toInt();
                          triptime = value.fetchedDatas[index]
                            ['tripTime'];

                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                  TripDetailsScreen(
                                      earnings: value.fetchedDatas[index]),
                                  transition: Transition.fadeIn);
                            },
                            child: CustomTrips(
                              isfromTransactionDetails: false,
                              itemCount: 1,
                              deliverytext: ConstContentService()
                                  .deliveryTypeMethod(orderType.toString()),
                              orderId: value.fetchedDatas[index]['orderDetails']
                                          ?['orderCode']
                                      ?.toString() ??
                                  '',
                                  ispaid: value.fetchedDatas[index]["isPaid"]??false,
                              dateText: createdAtString,
                              timeText: createdAtString,
                              tripAmount: tripAmount ?? '',
                              tripTime: triptime,
                              tripKm: tripKm ?? '',
                              rating: ratingList.toString(),
                            ),
                          );
                        },
                      );
                    }
                  },
                )
                ),
              )
            ])),
      ),
    );
  }

  int i = 0; // dont play with this line
}

class EarningPaginations with ChangeNotifier {
  bool isLoading = false;

  bool moreDataLoading = false;

  int limit = 5;
  List fetchedDatas = [];
  dynamic datas;

  dynamic totalCount;
  dynamic fetchCount;
  double deliverycharge = 0.0;
  double totaltips = 0.0;

  Future<void> clearData() async {
    fetchedDatas.clear();
    datas = 0;
    totalCount = 0;
    fetchCount = 0;
    deliverycharge = 0.00;
    totaltips = 0.00;
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchEarningData({startdate, endDate, int offset = 0}) async {
    try {
      print("jsbjh shhs");
      moreDataLoading = true;
      notifyListeners();

      if (offset == 0) {
        isLoading = true;
        notifyListeners();
      }

      var response = await http.get(
        Uri.parse(
           //'${API.earningsApi}acceptedById=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&tripStatus=delivered'),
            '${API.earnings}deliverymanId=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&earningType=deliveryman'),
        headers: {
          'Authorization': 'Bearer $Usertoken',
          'Content-Type': 'application/json',
          'userId': UserId,
        },
      );
      print(
        //  'earningsapi${API.earningsApi}acceptedById=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&tripStatus=delivered');
          'earningsapi${API.earnings}deliverymanId=$UserId&limit=$limit&offset=$offset&fromDate=$startdate&toDate=$endDate&earningType=deliveryman');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
 datas = result['data']["totalEarning"];
        totalCount = result['data']['totalCount'];
        fetchCount = result['data']['fetchCount'];
        // 👇 Only update tips and delivery charge when fetching the first page
        if (offset == 0) {
          deliverycharge =
              (result['data']['totalAmountForUser'] ?? 0).toDouble();
          totaltips = (result['data']['totalAmountForTip'] ?? 0).toDouble();
        }
        // deliverycharge = (result['data']['totalAmountForUser'] ?? 0).toDouble();
        // totaltips = (result['data']['totalAmountForTip'] ?? 0).toDouble();

        fetchedDatas.addAll(result['data']['result']);
       
        notifyListeners();
         if (fetchedDatas.isEmpty) {
          isLoading = false;
          notifyListeners();
        }

        if (fetchedDatas.isNotEmpty) {
          isLoading = false;
          notifyListeners();
        }

        print(response.request);
        print('Total Length ... is ..');
        logg.i(result['data']['data'].length);

        for (int i = 0; i < fetchedDatas.length; i++) {
          print(
              '${fetchedDatas[i]['_id']}  === = =>> $totalCount  $fetchCount');
        }
      } else {
        if (fetchedDatas.isEmpty) {
          isLoading = false;
          notifyListeners();
        }

        logg.i('${response.statusCode} ====<<status code issue>>');
      }
    } catch (e) {
      print('Its an Exception Error $e ');
    } finally {
      moreDataLoading = false;
      notifyListeners();
    }
  }
}

DateTime? rangeStart;
DateTime? rangeEnd;

class MultiDateCalendar extends StatefulWidget {
  const MultiDateCalendar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MultiDateCalendarState createState() => _MultiDateCalendarState();
}

class _MultiDateCalendarState extends State<MultiDateCalendar> {
  final Set<DateTime> _selectedDates = {};

  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      rangeStartDay: rangeStart,
      rangeEndDay: rangeEnd,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          // _selectedDay = selectedDay;
          rangeStart = selectedDay;
          rangeEnd = selectedDay;
          _focusedDay = focusedDay;
        });
        print(rangeStart);
        print(rangeEnd);
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          rangeStart = start;
          rangeEnd = end;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.month,
      rangeSelectionMode: RangeSelectionMode.enforced,
      calendarStyle: CalendarStyle(
          markerSizeScale: 0.2,
          markersAnchor: 0.5,
          rangeHighlightScale: 0.2,
          markerMargin: const EdgeInsets.symmetric(horizontal: 0.2),
          rangeStartDecoration: BoxDecoration(
            color: Customcolors.darkPurple,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: Customcolors.darkPurple,
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: BoxDecoration(
            color: Customcolors.darkPurple,
            shape: BoxShape.circle,
          ),
          rangeHighlightColor: Customcolors.decorationGreen,
          selectedTextStyle: CustomTextStyle.blacktext),
    );
  }
}

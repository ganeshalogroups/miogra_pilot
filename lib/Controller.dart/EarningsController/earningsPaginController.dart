// // ignore_for_file: depend_on_referenced_packages

// import 'dart:convert';
// import 'package:miogra_service/Const.dart/const_variables.dart';
// import 'package:miogra_service/UrlList.dart/api.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:logger/logger.dart';

// class EarningPaginController extends GetxController {
//   EarningPaginController({DateTime? ddd}) : dateTime = ddd ?? DateTime.parse('2024-10-09');
     

//   String usertoken = getStorage.read("Usertoken") ?? '';
//   String userId = getStorage.read("UserId") ?? '';

//   final PagingController<int, dynamic>  earnPagingController =   PagingController(firstPageKey: 0);
    

//   static const int perPage = 3;

//   // DateTime dateTime = DateTime.parse('2024-10-09');
//   DateTime dateTime = DateTime.now();

//   @override
//   void onInit() {
//     super.onInit();
//     logg.w('HE is Executing...');
//     earnPagingController.addPageRequestListener((pageKey) {

//       fetchEarning(pageKey, dateTime, dateTime);
//     });
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     Future.delayed(Duration(seconds: 1), () => earnPagingController.refresh());
//   }

//   // Function to clear data and load new data

//   void refreshEarnings(DateTime fromDate, DateTime toDate) {
//     earnPagingController.refresh(); // Clears all previous data

//     fetchEarning(earnPagingController.firstPageKey, fromDate, toDate); 
      
//   }

//   Future<void> fetchEarning(int pageKey, DateTime fromDate, DateTime toDate) async {
    

//     print('Fetch Earnings Working ...');


//     try {

//       print('Checc..1');
//       await earningGet( pageKey, API.earningsApi, earnPagingController, fromDate, toDate);
         
//     } catch (e) {
//       print('Checc..2 $e');
//       earnPagingController.error = 'Error: $e';
//     }
//   }

//   var ddd = '2024-10-09';

//   Future<void> earningGet(
//       int pageKey,
//       String apiUrl,
//       PagingController<int, dynamic> pagingController,
//       DateTime fromDate,
//       DateTime toDate) async {
//     try {

// print('Checc..3');

//       var response = await http.get(
//         Uri.parse(
//             '${apiUrl}acceptedById=$userId&limit=$perPage&offset=$pageKey&fromDate=$fromDate&toDate=$toDate&tripStatus=delivered'),
//         headers: {
//           'Authorization': 'Bearer $usertoken',
//           'Content-Type': 'application/json',
//           'userId': userId,
//         },
//       );

//       print('Checc..4');

//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {

//             print('Checc..5');

//         final result = jsonDecode(response.body);
//         final newItems = result["data"]["data"];
//         final isLastPage = newItems.length < perPage;

//         final existingItems    = pagingController.itemList ?? [];
//         final existingItemIds  = existingItems.map((item) => item["_id"]).toSet();
//         final filteredNewItems = newItems.where((item) => !existingItemIds.contains(item["_id"])).toList();
            
            

//         if (isLastPage) {
//           pagingController.appendLastPage(filteredNewItems);
//         } else {
//           final nextPageKey = pageKey + 1;
//           pagingController.appendPage(filteredNewItems, nextPageKey);
//         }

        
//       }else{


//           print('Checc..6  ${response.request} ');
        
//       }
//     } catch (e) {

//       print('Checc..7 $e');

//       pagingController.error = 'Error: $e';
//     }
//   }

//   @override
//   void onClose() {
//     earnPagingController.dispose();
//     super.onClose();
//   }

      
//       void clearEarningsData() {
//       earnPagingController.itemList?.clear(); // Clear the loaded items
//       earnPagingController.refresh(); // Refresh the controller to trigger re-fetch

//       logg.i('Earnings data cleared and refreshed.');
//     }

// }




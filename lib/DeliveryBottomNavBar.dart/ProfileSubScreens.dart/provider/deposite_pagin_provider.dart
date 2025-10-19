// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

Logger logg = Logger();

class DepositProviderPagin with ChangeNotifier {
  bool isLoading = false;

  bool moreDataLoading = false;

  int limit = 10;
  List fetchedDatas = [];

  dynamic totalCount;
  dynamic fetchCount;

  Future<void> clearData() async {
    fetchedDatas.clear();
    totalCount = 0;
    fetchCount = 0;
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
            '${API.depositDepositedGetApi}?limit=$limit&offset=$offset&assignedToId=$UserId'),
        //${API.depositDepositedGetApi}?limit=$limit&offset=$offset&toDate=09-07-2024&value=&depositStatus=request&assignedToId=$userId
        headers: {
          'Authorization': 'Bearer $Usertoken',
          'Content-Type': 'application/json',
          'userId': UserId,
        },
      );
      print(
          "deposite api++++++++++ ${API.depositDepositedGetApi}?limit=$limit&offset=$offset&assignedToId=$UserId");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        totalCount = result['data']['totalCount'];
        fetchCount = result['data']['fetchCount'];

        fetchedDatas.addAll(result['data']['data']);
        isLoading = false; // Always set loading false after response
        notifyListeners();

        print(response.request);
        print('Total Length ... is ..');
        logg.i(result['data']['data'].length);

        for (int i = 0; i < fetchedDatas.length; i++) {
          print(
              '${fetchedDatas[i]['_id']}  === = =>> $totalCount  $fetchCount');
        }
      } else {
        isLoading = false; // Always set loading false on error
        notifyListeners();

        logg.i('${response.statusCode} ====<<status code issue>>');
      }
    } catch (e) {
      print('Its an Exception Error $e');
    } finally {
      moreDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDeposit(
      {required String depositId,
      required BuildContext context,
      required Map<String, dynamic> updatedData}) async {
    try {
      isLoading = true;
      notifyListeners();

      var response = await http.put(
        Uri.parse('${API.depositUPDATE}/$depositId'),
        headers: {
          'Authorization': 'Bearer $Usertoken',
          'Content-Type': 'application/json',
          'userId': UserId,
        },
        body: jsonEncode(updatedData),
      );
      print("deposite update ____________________");
      print("${API.depositUPDATE}/$depositId");
      logg.i(
          "Updating deposit stsuscode: ${response.statusCode} - ${response.body}");
      print(response.body);
      logg.i("Updating deposit: ${response.statusCode} - ${response.body}");
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(response.body);
        // Find the index of the updated item
        int index = fetchedDatas.indexWhere((item) => item['_id'] == depositId);
        if (index != -1) {
          fetchedDatas[index] = result['data']; // Update the item in the list
          if (context.mounted) {
            Navigator.pop(context); // ✅ Safe pop
          }
          String stdd = DateFormat('yyyy-MM-dd').format(DateTime.now());
          String endd = DateFormat('yyyy-MM-dd').format(DateTime.now());
          Provider.of<DepositProviderPagin>(context, listen: false)
              .clearData()
              .then((value) {
            Provider.of<DepositProviderPagin>(context, listen: false)
                .fetchEarningData(startdate: stdd, endDate: endd);
          });
          //      Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreenMultiTrip()), // Replace with your screen
          // );
          notifyListeners();
        }
      } else {
        logg.e("Failed to update deposit: ${response.statusCode}");
      }
    } catch (e) {
      logg.e("Update Exception: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

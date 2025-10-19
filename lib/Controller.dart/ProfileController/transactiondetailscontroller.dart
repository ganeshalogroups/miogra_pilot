// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class TransactionDetailsController extends GetxController {
  String? userId = getStorage.read("UserId");
  String? usertoken = getStorage.read("Usertoken");

  var dataLoading = false.obs;
  var getTransaction = <dynamic>[].obs; // Initialize as an observable list

  Future<void> getTransactionDetail() async {
    try {
      dataLoading.value = true;
      final response =
          await http.get(Uri.parse(API.transactionGetApi), headers: {
        'Authorization': 'Bearer $usertoken',
        'Content-Type': 'application/json',
        'userId': userId!,
      });

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        getTransaction.value = result['data']['data'] ?? [];
      } else {
        getTransaction.clear();
        throw Exception('Failed to load Get Deposit');
      }
    } catch (e) {
      // print('$error');
    } finally {
      dataLoading.value = false;
    }
  }
}

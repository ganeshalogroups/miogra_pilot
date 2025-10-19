// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class DepositController extends GetxController {
  // String? userId = getStorage.read("UserId") ?? '';
  // String? usertoken = getStorage.read("Usertoken") ?? '';

  //update deposite

  Future<void> updateDeposit(
      String? fromDate, String? toDate, String vendorId) async {

    try {
      print("check22222");
      var response = await http.post(
        Uri.parse(API.depositApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $Usertoken',
          'userid': UserId!,
          'token': Usertoken!,
        },
        body: jsonEncode(<String, dynamic>{
          "assignedToId": UserId,
          "files": [],
          "instructions": [],
          "paymentType": "bankTransfer",
          "proof": null,
          "additionalInstructions": null,
          "billDate": null,
          "invoicePath": null,
          "payedDate": null,
          "lastDate": null,
          "fromDate": fromDate,
          "toDate": toDate,
        }),
      );
      print("depost link +++++++++++++++++++++++++++++++++++");
      print("deposite sttus code ${response.statusCode}");
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 202) {
        var result = jsonDecode(response.body);
        print(result);
      } else {}
    } catch (e) {
      debugPrint('The Error in Deposit  is $e');
    }
  }

  var dataRequestLoading = false.obs;
  var getRequestDeposit = <dynamic>[].obs; // Initialize as an observable list

  Future<void> getRequestDepositApi() async {
    try {
      dataRequestLoading.value = true;
      final response =
          await http.get(Uri.parse(API.depositRequestGetApi), headers: {
        'Authorization': 'Bearer $Usertoken',
        'Content-Type': 'application/json',
        'userId': UserId!,
      });
      print("deposite get api ${API.depositRequestGetApi}");
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        getRequestDeposit.value = result['data']['data'] ?? [];
      } else {
        getRequestDeposit.clear();
        throw Exception('Failed to load Get Deposit');
      }
    } catch (e) {
      // print('$e');
    } finally {
      dataRequestLoading.value = false;
    }
  }

  var dataDepositedLoading = false.obs;
  var getDepositedDeposit = <dynamic>[].obs; // Initialize as an observable list

  Future<void> getDepositedDepositApi() async {
    try {
      dataDepositedLoading.value = true;
      final response = await http
          .get(Uri.parse("${API.depositDepositedGetApi}?limit=200"), headers: {
        'Authorization': 'Bearer $Usertoken',
        'Content-Type': 'application/json',
        'userId': UserId!,
      });

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        getDepositedDeposit.value = result['data']['data'] ?? [];
      } else {
        getDepositedDeposit.clear();
        throw Exception('Failed to load Get Deposit');
      }
    } catch (e) {
      // print('$e');
    } finally {
      dataDepositedLoading.value = false;
    }
  }
}

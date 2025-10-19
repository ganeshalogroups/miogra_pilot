// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:miogra_service/Model.dart/RegisterModel.dart/getregionmodel.dart';
import 'package:miogra_service/UrlList.dart/api.dart';

class RegionController extends GetxController {
  String usertoken = getStorage.read("Usertoken") ?? '';
  GetRegion? getRegionModel;
  List<Datum> regions = [];
  var dataLoading = false.obs;

  Future<void> getRegion() async {
    try {
      dataLoading.value = true;
      final response = await http.get(Uri.parse(API.getRegionApi), headers: {
        'Authorization': 'Bearer $usertoken',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        getRegionModel = GetRegion.fromJson(data);
        regions = getRegionModel?.data.data ?? [];
       
      } else {
        throw Exception('Failed to load regions');
      }
    } catch (e) {
       // print('$error');

    } finally {
      dataLoading.value = false;
    }
  }
  
}



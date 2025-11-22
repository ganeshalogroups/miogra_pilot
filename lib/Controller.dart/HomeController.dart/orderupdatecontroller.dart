// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:miogra_service/Const.dart/const_variables.dart';
import 'package:miogra_service/Const.dart/time_convert_values.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/orderonprocessstatus.dart';
import 'package:miogra_service/Controller.dart/HomeController.dart/tripscontroller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/backtoorderscreen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/droporder.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/map_tracking/map_value_controller.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/reachdroplocation.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/tripsummaryscreen.dart';
import 'package:miogra_service/UrlList.dart/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class OrderUpdateController extends GetxController {
  String usertoken = getStorage.read("Usertoken");
  String userId = getStorage.read("UserId");
  var isOrderUpdateLoading = false.obs;
  var orderErrorMessage = ''.obs; // To store any error message
  final NewTripsController newTripsController = Get.put(NewTripsController());
  final OrderOnProcessController orderOnProcessController =
      Get.put(OrderOnProcessController());
  final MapValueController mapValueController = Get.put(MapValueController());

  Future<void> updateAcceptOrderStatus(
    String orderId,
    String id,
    String acceptedById,
    DateTime assignedAt,
    String baseKm,
  ) async {
    isOrderUpdateLoading.value = true;
    orderErrorMessage.value = ''; // Clear previous error on new request

    try {
      isOrderUpdateLoading.value = true;
      final response = await http.put(
        Uri.parse(API.acceptTripsApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
          'userid': userId,
          'token': usertoken
        },
        body: jsonEncode({
          "_id": id,
          "orderId": orderId,
          "tripStatus": "accepted",
          "acceptedById": UserId,
          "assignedAt": assignedAt.toIso8601String(),
          "baseKm": baseKm,
          "assignedToId": UserId
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        String dateCurent = TimerdataService().apiselectdateCallDate();
        print(result);
        orderOnProcessController.orderOnProcessStatus(
            startdate: dateCurent == "null" ? currentDateGlobal : dateCurent,
            enddate: dateCurent == "null" ? currentDateGlobal : dateCurent);
        mapValueController.isAccept.value = true;

        orderErrorMessage.value = ''; // Clear error on success
      } else {
        var errorResponse = jsonDecode(response.body);
        if (errorResponse['code'] == 400 &&
            errorResponse['message'] == "Trip Has Already Accepeted") {
          orderErrorMessage.value =
              "Trip Has Already Accepted"; // Set the error message
          Get.snackbar(
            'Error',
            'Trip has already been accepted.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          orderErrorMessage.value =
              "Failed to update order status"; // Handle other errors
        }
      }
    } catch (e) {
      orderErrorMessage.value = 'Error occurred while updating order status';
    } finally {
      isOrderUpdateLoading.value = false;
    }
  }

//reached Restaurent

  var isReachedOrderUpdateLoading = false.obs;
  dynamic reachedOrderUpdateData;

  Future<void> updateReachedRestaurentStatus(
      String id, DateTime reachedPickupedAt) async {
    isReachedOrderUpdateLoading.value = true;

    String reachedPickup = reachedPickupedAt.toIso8601String();

    try {
      final response = await http.put(
        Uri.parse(API.reachedRestaurentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
          'userid': userId,
          'token': usertoken
        },
        body: jsonEncode({
          "_id": id,
          "tripStatus": "reachedPickup",
          "reachedPickUpedAt": reachedPickup,
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        reachedOrderUpdateData = result;
        orderOnProcessController.orderOnProcessStatus(
            startdate: currentDateGlobal, enddate: currentDateGlobal);
        newTripsController.getNewTrips();
        Get.off(() => TripSummary(
              id: id,
              orderId: result["data"]["orderId"],
            ));
      } else {
        reachedOrderUpdateData = null;
      }
    } catch (e) {
      // print('$e');
    } finally {
      isReachedOrderUpdateLoading.value = false;
    }
  }

// picked order

  var isPickedOrderUpdateLoading = false.obs;
  dynamic pickedOrderUpdateData;

  Future<void> updatePickedRestaurentStatus(
      String id, DateTime pickededAt, String orderId) async {
    isPickedOrderUpdateLoading.value = true;

    String picked = pickededAt.toIso8601String();

    try {
      final response = await http.put(
        Uri.parse(API.pickedRestaurentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
          'userid': userId,
          'token': usertoken
        },
        body: jsonEncode({
          "_id": id,
          "tripStatus": "pickuped",
          "pickUpedAt": picked,
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        pickedOrderUpdateData = result;
        orderOnProcessController.orderOnProcessStatus(
            startdate: currentDateGlobal, enddate: currentDateGlobal);
        newTripsController.getNewTrips();
        Get.off(() => ReachDropLocationBottomSheet(
              roundTrip: false,
              id: id,
              orderId: orderId,
            ));
      } else {
        pickedOrderUpdateData = null;
        print("else error");
        print("else error  ${response.statusCode}");
      }
    } catch (e) {
      // print('$e');
       print("catch error   $e");
    } finally {
      isPickedOrderUpdateLoading.value = false;
    }
  }
// picked order

  var isStartRoundTriprUpdateLoading = false.obs;
  dynamic startRoundTripUpdateData;

  Future<void> updatestartRoundTripUpdateDataStatus(
      String id, DateTime roundTripdAt, String orderId) async {
    isStartRoundTriprUpdateLoading.value = true;

    String roundTripStart = roundTripdAt.toIso8601String();

    try {
      final response = await http.put(
        Uri.parse(API.pickedRestaurentApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
          'userid': userId,
          'token': usertoken
        },
        body: jsonEncode({
          "_id": id,
          "tripStatus": "roundTripStarted",
          "roundTripStartedAt": roundTripStart,
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        startRoundTripUpdateData = result;
        orderOnProcessController.orderOnProcessStatus(
            startdate: currentDateGlobal, enddate: currentDateGlobal);
        newTripsController.getNewTrips();
        Get.off(() => ReachDropLocationBottomSheet(
            roundTrip: true, id: id, orderId: orderId));
      } else {
        startRoundTripUpdateData = null;
      }
    } catch (e) {
      // print('$e');
    } finally {
      isStartRoundTriprUpdateLoading.value = false;
    }
  }

//reached delivery location

  var isReachedDeliveryUpdateLoading = false.obs;
  dynamic reachedDeliveryUpdateData;

  Future<void> updateReachedDeliveryStatus(
      String id, DateTime reachedPickUpedAt) async {
    isReachedDeliveryUpdateLoading.value = true;

    String reachedPickedUp = reachedPickUpedAt.toIso8601String();

    try {
      final response = await http.put(
        Uri.parse(API.reachedDeliveryApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
          'userid': userId,
          'token': usertoken
        },
        body: jsonEncode({
          "_id": id,
          "tripStatus": "reachedDelivery",
          "reachedDeliveryAt": reachedPickedUp,
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        reachedDeliveryUpdateData = result;
        newTripsController.getNewTrips();
        orderOnProcessController.orderOnProcessStatus(
            startdate: currentDateGlobal, enddate: currentDateGlobal);
        Get.off(() => DropOrder(id: id));
      } else {
        reachedDeliveryUpdateData = null;
      }
    } catch (e) {
      // print('$e');
    } finally {
      isReachedDeliveryUpdateLoading.value = false;
    }
  }

//Delivered Order

  var isDeliveredUpdateLoading = false.obs;
  dynamic deliveredUpdateData;

  Future<void> updateDeliveredStatus(String id, DateTime deliveredAt) async {
    isDeliveredUpdateLoading.value = true;
    // String delivered = deliveredAt.toIso8601String();
    final String currentTimeUtc = DateTime.now().toUtc().toIso8601String();

    try {
      final response = await http.put(
        Uri.parse(API.reachedDeliveryApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usertoken',
          'userid': userId,
          'token': usertoken
        },
        body: jsonEncode({
          "_id": id,
          "tripStatus": "delivered",
          "deliveredAt": currentTimeUtc,
          "handOverTheOrder": true,
          "collectedCash": true
        }),
      );
        //var r = jsonDecode(response.body);
//print("RESPONSE $r");
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        deliveredUpdateData = result;
        newTripsController.getNewTrips();
        orderOnProcessController.orderOnProcessStatus(
            startdate: currentDateGlobal, enddate: currentDateGlobal);
        Get.offAll(() => BackToOrder());

        print("API CALLED");
      } else {
        deliveredUpdateData = null;
         print("API NOT CALLED");
      }
    } catch (e) {
      // print('$e');
    } finally {
      isDeliveredUpdateLoading.value = false;
    }
  }
}

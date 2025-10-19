import 'package:get_storage/get_storage.dart';

class ConstContentService {
  deliveryTypeMethod(String type) {
    if (type == "restaurant") {
      return 'FoodDelivery';
    } else if (type == "services") {
      return "Package";
    } else if (type == "meat") {
      return "Meat";
    } else {
      return type.toString();
    }
  }

  deliveryBottonTypeMethod(String type) {
    if (type == "restaurant") {
      return 'Picked Order';
    } else if (type == "services") {
      return "Picked Parcel";
    } else if (type == "meat") {
      return "Picked Order";
    } else {
      return type.toString();
    }
  }

  stringToDouble(String value) {
    return double.parse(value.toString()).toStringAsFixed(2);
  }

  kmToTime(String value) {
    double totalKmsInt = double.tryParse(value.toString()) ??
        0; // Convert the string to an integer
    int tripTimeInMinutes = (totalKmsInt * 5).toInt();
    return tripTimeInMinutes;
  }
}

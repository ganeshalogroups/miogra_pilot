import 'package:get/get.dart';

class MapValueController extends GetxController {

  var orderStaus = "".obs; // `obs` makes it observable
  var isAccept = false.obs; 
  void orderStatusChange(val) {
    orderStaus.value = val.toString();
  }


  void isAccepted(val) {
    isAccept.value = val;
  }


}

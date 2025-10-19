import 'package:intl/intl.dart';

class TimerService {
  String formatDate({required String dateStr}) {
    DateTime dateTime = DateTime.parse(dateStr);
    dateTime = dateTime.add(Duration(hours: 5, minutes: 30));
    String formattedDate =
        DateFormat("d MMM yyyy 'at' h:mma").format(dateTime).toLowerCase();
    return formattedDate;
  }

  String apiCallDate({DateTime? dateStr}) {
    DateTime now = DateTime.now();
    String formattedStartDateTime = DateFormat('MM-dd-yyyy').format(now);

    return formattedStartDateTime;
  }
}


class TimerdataService {
  String formatDate({required String dateStr}) {
    DateTime dateTime = DateTime.parse(dateStr);
    dateTime = dateTime.add(Duration(hours: 5, minutes: 30));
    String formattedDate =
        DateFormat("d MMM yyyy 'at' h:mma").format(dateTime).toLowerCase();
    return formattedDate;
  }

  String apiselectdateCallDate({DateTime? dateStr}) {
    DateTime now = DateTime.now();
    String formattedStartDateTime = DateFormat('yyyy-MM-dd').format(now);

    return formattedStartDateTime;
  }
}
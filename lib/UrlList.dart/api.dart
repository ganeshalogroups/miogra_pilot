import 'package:miogra_service/Const.dart/const_variables.dart';

class API {
  //Live
//  static String microService = "https://api.thefastx.com/"; 
//Dev
  // static String microService = "https://dev.thefastx.com/";
   static String microService = "https://miogra.com/";

  //request-Login api
  static String requestOtp = '${microService}api/user/requestOtp';
  static String login = '${microService}api/user/authUser/login';

  //verify otp
  static String otp = '${microService}api/user/verifyOtp';

  //register
  static String register = '${microService}api/user/authUser/register';

  //image upload
  // static String bannerUpload = '${microService}api/utility/file/bannerUpload';
  static String bannerUpload =
      '${microService}api/utility/file/foodImageUpload';

  //region
  static String getRegionApi = '${microService}api/user/region?status=true';

  //token
  static String token = '${microService}api/user/authlist/token';

  //new trips
  static String getNewTripsApi =
      "${microService}api/order/trip/new/list?limit=50&vendorAdminId=";
  static String getCompletedTripsApi = "${microService}api/order/trip/new/list";

  //trips by id
  static String getTripsbyidApi = "${microService}api/order/trip/";

  //accept trips
  static String acceptTripsApi = "${microService}api/order/trip/new/accept";

  //reached trips
  static String reachedRestaurentApi =
      '${microService}api/order/trip/new/accept';

  //picked trips
  static String pickedRestaurentApi =
      '${microService}api/order/trip/new/accept';

  //reached Delivery
  static String reachedDeliveryApi = '${microService}api/order/trip/new/accept';

  //delivered order
  static String orderDelivered = '${microService}api/order/trip/new/accept';

  //order In process Status
  static String barStatus = '${microService}api/order/trip/new/statusFilter';

  //updateLastSeen
  static String updateLastSeen = '${microService}api/user/authUser';
  //{{localURL}}/api/trip/earningList?acceptedById=6763ad47d4778b7366f747bb

  //earningsfilterbycalendor
  static String earningsApi = '${microService}api/order/trip/earningList?';

  //Notifications
  static String notificationsApi =
      '${microService}api/utility/notification/pagination';

  //charts
  static String chartsApi =
      '${microService}api/order/income/getIncomeForDeliveryman';

  //activestatus
  static String activeStatusApi = '${microService}api/user/authUser';

  //profileupdate
  static String profileUpdateApi = '${microService}api/user/authUser';

  //deposit put
  static String depositUpdateApi =
      '${microService}api/order/deposit/depositCreated?assignedToId=$UserId';
  static String depositApi = '${microService}api/order/deposit/depositCreated';
  static String depositUPDATE = '${microService}api/order/deposit';

  //deposit Request get
  static String depositRequestGetApi =
      '${microService}api/order/deposit/depositGetPagination?limit=200&depositStatus=request&assignedToId=$UserId';

  //deposit Deposited get
  static String depositDepositedGetApi =
      '${microService}api/order/deposit/depositGetPagination';

  //getDeliverymanProfile
  static String profileGetApi = '${microService}api/user/authUser/deliveryman';

  //getTransactionApi
  static String transactionGetApi =
      '${microService}api/order/deposit/depositGetPagination';

  //redirecturl
  static String redirecturl = '${microService}api/utility/appConfig/';

  // static String baseUrl =
  //     //'https://www.thefastx.com/';
  //     'http://ec2-3-110-51-78.ap-south-1.compute.amazonaws.com:8000/';

  // //request-Login api
  // static String login = '${baseUrl}api/requestOtp';

  // //verify otp
  // static String otp = '${baseUrl}api/verifyOtp';

  // //register
  // static String register = '${baseUrl}api/authUser/register';

  // //image upload
  // static String bannerUpload = '${baseUrl}api/file/bannerUpload';

  // //region
  // static String getRegionApi = '${baseUrl}api/region?status=true';

  // //token
  // static String token = '${baseUrl}api/authlist/token';

  // //new trips
  // static String getNewTripsApi =
  //     "${baseUrl}api/trip/new/list?limit=50&vendorAdminId=";
  // static String getCompletedTripsApi = "${baseUrl}api/trip/new/list";

  // //trips by id
  // static String getTripsbyidApi = "${baseUrl}api/trip/";

  // //accept trips
  // static String acceptTripsApi = "${baseUrl}api/trip/new/accept";

  // //reached trips
  // static String reachedRestaurentApi = '${baseUrl}api/trip/new/accept';

  // //picked trips
  // static String pickedRestaurentApi = '${baseUrl}api/trip/new/accept';

  // //reached Delivery
  // static String reachedDeliveryApi = '${baseUrl}api/trip/new/accept';

  // //delivered order
  // static String orderDelivered = '${baseUrl}api/trip/new/accept';

  // //order In process Status
  // static String barStatus = '${baseUrl}api/trip/new/statusFilter';

  // //updateLastSeen
  // static String updateLastSeen = '${baseUrl}api/authUser';
  // //{{localURL}}/api/trip/earningList?acceptedById=6763ad47d4778b7366f747bb

  // //earningsfilterbycalendor
  // static String earningsApi = '${baseUrl}api/trip/earningList?';

  // //Notifications
  // static String notificationsApi = '${baseUrl}api/notification/pagination';

  // //charts
  // static String chartsApi = '${baseUrl}api/income/getIncomeForDeliveryman';

  // //activestatus
  // static String activeStatusApi = '${baseUrl}api/authUser';

  // //profileupdate
  // static String profileUpdateApi = '${baseUrl}api/authUser';

  // //deposit put
  // static String depositUpdateApi =
  //     '${baseUrl}api/deposit/depositCreated?assignedToId=$UserId';
  // static String depositApi = '${baseUrl}api/deposit/depositCreated';
  // static String depositUPDATE = '${baseUrl}api/deposit';

  // //deposit Request get
  // static String depositRequestGetApi =
  //     '${baseUrl}api/deposit/depositGetPagination?limit=200&depositStatus=request&assignedToId=$UserId';

  // //deposit Deposited get
  // static String depositDepositedGetApi =
  //     '${baseUrl}api/deposit/depositGetPagination';

  // //getDeliverymanProfile
  // static String profileGetApi = '${baseUrl}api/authUser/deliveryman';

  // //getTransactionApi
  // static String transactionGetApi =
  //     '${baseUrl}api/deposit/depositGetPagination';

  // //redirecturl
  // static String redirecturl = '${baseUrl}api/appConfig/';
}

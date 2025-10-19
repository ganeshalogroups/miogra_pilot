// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  int code;
  bool status;
  String message;
  TokenModelData data;

  TokenModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: TokenModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class TokenModelData {
  String token;
  DataData data;

  TokenModelData({
    required this.token,
    required this.data,
  });

  factory TokenModelData.fromJson(Map<String, dynamic> json) => TokenModelData(
        token: json["token"],
        data: DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "data": data.toJson(),
      };
}

class DataData {
  String userName;
  String email;
  String userId;
  String mobileNo;
  String role;
  String uuid;

  DataData({
    required this.userName,
    required this.email,
    required this.userId,
    required this.mobileNo,
    required this.role,
    required this.uuid,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        userName: json["userName"],
        email: json["email"],
        userId: json["userId"],
        mobileNo: json["mobileNo"],
        role: json["role"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "userId": userId,
        "mobileNo": mobileNo,
        "role": role,
        "uuid": uuid,
      };
}

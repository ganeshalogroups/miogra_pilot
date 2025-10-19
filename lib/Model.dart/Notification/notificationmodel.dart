// To parse this JSON data, do
//
//     final getNotificationModel = getNotificationModelFromJson(jsonString);

import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String str) =>
    GetNotificationModel.fromJson(json.decode(str));

String getNotificationModelToJson(GetNotificationModel data) =>
    json.encode(data.toJson());

class GetNotificationModel {
  int code;
  bool status;
  String message;
  Data data;

  GetNotificationModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationModel(
        code: json["code"] ?? '',
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        data: Data.fromJson(json["data"] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int totalCount;
  int fetchCount;
  List<Datum> data;

  Data({
    required this.totalCount,
    required this.fetchCount,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCount: json["totalCount"] ?? '',
        fetchCount: json["fetchCount"] ?? '',
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "fetchCount": fetchCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? notificationType;
  String? orderId;
  String? customerId;
  String? parentAdminId;
  String? productCtaegoryId;
  String? title;
  String? body;
  String? image;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.notificationType,
    this.orderId,
    this.customerId,
    this.parentAdminId,
    this.productCtaegoryId,
    this.title,
    this.body,
    this.image,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        notificationType: json["notificationType"],
        orderId: json["orderId"],
        customerId: json["customerId"],
        parentAdminId: json["parentAdminId"],
        productCtaegoryId: json["productCtaegoryId"],
        title: json["title"],
        body: json["body"],
        image: json["image"],
        deleted: json["deleted"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "notificationType": notificationType,
        "orderId": orderId,
        "customerId": customerId,
        "parentAdminId": parentAdminId,
        "productCtaegoryId": productCtaegoryId,
        "title": title,
        "body": body,
        "image": image,
        "deleted": deleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

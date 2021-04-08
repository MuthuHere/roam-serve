// To parse this JSON data, do
//
//

import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  ResponseModel({
    this.dateTime,
    this.imageUrl,
    this.additionalInfo,
    this.location,
    this.category,
  });

  String dateTime;
  String imageUrl;
  String additionalInfo;
  String location;
  String category;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    dateTime: json["dateTime"],
    imageUrl: json["imageUrl"],
    additionalInfo: json["additionalInfo"],
    location: json["location"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "dateTime": dateTime,
    "imageUrl": imageUrl,
    "additionalInfo": additionalInfo,
    "location": location,
    "category": category,
  };
}

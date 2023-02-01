// To parse this JSON data, do
//
//     final categoryModelData = categoryModelDataFromJson(jsonString);

import 'dart:convert';

List<CategoryModelData> categoryModelDataFromJson(String str) => List<CategoryModelData>.from(json.decode(str).map((x) => CategoryModelData.fromJson(x)));

String categoryModelDataToJson(List<CategoryModelData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModelData {
  CategoryModelData({
    this.categoryId,
    this.categoryTitle,
  });

  int? categoryId;
  String? categoryTitle;

  factory CategoryModelData.fromJson(Map<String, dynamic> json) => CategoryModelData(
    categoryId: json["categoryId"],
    categoryTitle: json["categoryTitle"],
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryTitle": categoryTitle,
  };
}

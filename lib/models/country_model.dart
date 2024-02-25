// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

Map<String, CountryModel> countryModelFromJson(String str) =>
    Map.from(json.decode(str)).map(
        (k, v) => MapEntry<String, CountryModel>(k, CountryModel.fromJson(v)));

class CountryModel {
  int cid;
  String name;
  String shortcode;
  String? excode;
  int? numcode;
  int phonecode;

  CountryModel({
    required this.cid,
    required this.name,
    required this.shortcode,
    required this.excode,
    required this.numcode,
    required this.phonecode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        cid: json["cid"],
        name: json["country"],
        shortcode: json["shortcode"],
        excode: json["excode"],
        numcode: json["numcode"],
        phonecode: json["phonecode"],
      );
}

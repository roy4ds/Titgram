// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

List<ChannelModel> channelModelFromJson(String str) => List<ChannelModel>.from(
    json.decode(str).map((x) => ChannelModel.fromJson(x)));

class ChannelModel {
  String id;
  String title;
  String? uname;
  String owner;
  int subscribers;
  String link;
  Photo? photo;

  ChannelModel({
    required this.id,
    required this.title,
    required this.uname,
    required this.owner,
    required this.subscribers,
    required this.link,
    required this.photo,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
        id: json["id"],
        title: json["title"],
        uname: json["uname"],
        owner: json["owner"],
        subscribers: json["subscribers"],
        link: json["link"],
        photo: json["photo"] == null ? null : Photo.fromJson(json["photo"]),
      );
}

class Photo {
  String smallFileId;
  String smallFileUniqueId;
  String bigFileId;
  String bigFileUniqueId;

  Photo({
    required this.smallFileId,
    required this.smallFileUniqueId,
    required this.bigFileId,
    required this.bigFileUniqueId,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        smallFileId: json["small_file_id"],
        smallFileUniqueId: json["small_file_unique_id"],
        bigFileId: json["big_file_id"],
        bigFileUniqueId: json["big_file_unique_id"],
      );
}

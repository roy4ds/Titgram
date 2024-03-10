// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String fname;
  String? lname;
  String? uname;
  String mobile;
  String email;
  String country;
  String? curr;
  String? apps;
  int? uchat;
  String fullName;
  bool? upgrade;
  Eps? eps;
  String uat;

  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.uname,
    required this.mobile,
    required this.email,
    required this.country,
    required this.curr,
    required this.apps,
    required this.uchat,
    required this.fullName,
    this.upgrade,
    this.eps,
    required this.uat,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fname: json["fname"],
        lname: json["lname"],
        uname: json["uname"],
        mobile: json["mobile"],
        email: json["email"],
        country: json["country"],
        curr: json["curr"],
        apps: json["apps"],
        uchat: json["uchat"],
        fullName: json["FullName"],
        upgrade: json["upgrade"],
        eps: json["eps"] == null ? null : Eps.fromJson(json["eps"]),
        uat: json["uat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "lname": lname,
        "uname": uname,
        "mobile": mobile,
        "email": email,
        "country": country,
        "curr": curr,
        "apps": apps,
        "uchat": uchat,
        "FullName": fullName,
        "upgrade": upgrade,
        "eps": eps?.toJson(),
        "uat": uat,
      };
}

class Eps {
  int id;
  String uid;
  String org;
  String role;
  int salary;
  DateTime csd;
  DateTime lastseen;
  String status;

  Eps({
    required this.id,
    required this.uid,
    required this.org,
    required this.role,
    required this.salary,
    required this.csd,
    required this.lastseen,
    required this.status,
  });

  factory Eps.fromJson(Map<String, dynamic> json) => Eps(
        id: json["id"],
        uid: json["uid"],
        org: json["org"],
        role: json["role"],
        salary: json["salary"],
        csd: DateTime.parse(json["csd"]),
        lastseen: DateTime.parse(json["lastseen"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "org": org,
        "role": role,
        "salary": salary,
        "csd": csd.toIso8601String(),
        "lastseen": lastseen.toIso8601String(),
        "status": status,
      };
}

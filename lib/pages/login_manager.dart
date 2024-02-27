import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:titgram/models/user_model.dart';

class LoginManager with ChangeNotifier {
  final box = Hive.box('user');
  final String session = 'session';
  LoginManager() {
    //
  }

  bool isLoggedIn() {
    if (box.get(session) != null) return true;
    return false;
  }

  void saveLoginSession(User user) {
    box.put(session, jsonEncode(user));
  }

  _Auth() {}

  void logout() {
    box.delete(session);
    notifyListeners();
  }
}

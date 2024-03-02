import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  void saveLoginSession(BuildContext context, User user) {
    box.put(session, userToJson(user));
    context.goNamed('home');
  }

  void logout(BuildContext context) {
    box.delete(session);
    context.goNamed('login');
    notifyListeners();
  }
}

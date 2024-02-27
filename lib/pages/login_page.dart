import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:titgram/incs/utils/login_forms.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  final String? restorationId = 'main';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSigningUp = false;
  late LoginForms loginForms;
  final box = Hive.box('app');

  @override
  void initState() {
    loginForms = LoginForms(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String titleText = isSigningUp ? "Signup" : "Login";
    String actionText = isSigningUp ? "Login" : "Signup";
    bool isdark = box.get('isdark', defaultValue: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              child: Text(actionText),
              onPressed: () {
                setState(() {
                  isSigningUp = !isSigningUp;
                });
              },
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: isSigningUp ? loginForms.signup() : loginForms.login()),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          box.put('isdark', !isdark);
        },
        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        child:
            Icon(isdark != true ? Icons.light_mode : Icons.dark_mode_rounded),
      ),
    );
  }
}

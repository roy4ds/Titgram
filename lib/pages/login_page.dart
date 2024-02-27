import 'package:flutter/material.dart';
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

  @override
  void initState() {
    loginForms = LoginForms(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String titleText = isSigningUp ? "Signup" : "Login";
    String actionText = isSigningUp ? "Login" : "Signup";

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
        onPressed: () {},
        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        child: const Icon(Icons.light_mode),
      ),
    );
  }
}

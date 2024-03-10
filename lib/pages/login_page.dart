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
    bool isdark = box.get('isdark', defaultValue: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Welcome",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(tabs: [
            Tab(
              child: Text("Login"),
            ),
            Tab(
              child: Text("Signup"),
            )
          ]),
        ),
        body: TabBarView(children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: loginForms.login(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: loginForms.signup(),
            ),
          ),
        ]),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            box.put('isdark', !isdark);
          },
          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
          child:
              Icon(isdark != true ? Icons.light_mode : Icons.dark_mode_rounded),
        ),
      ),
    );
  }
}

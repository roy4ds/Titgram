import 'package:flutter/material.dart';
import 'package:titgram/incs/api/roy4d_api.dart';
import 'package:titgram/incs/utils/form_master.dart';
import 'package:titgram/pages/login_manager.dart';

class LoginForms {
  final BuildContext context;
  late Roy4dApi roy4dApi;
  LoginForms(this.context) {
    roy4dApi = Roy4dApi(ctxt: context);
  }

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  TextEditingController unamecontroller = TextEditingController();
  TextEditingController passwdcontroller = TextEditingController();
  Widget login() {
    return Form(
      key: loginFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: unamecontroller,
              validator: (value) {
                if (value == null) {
                  return "Required";
                }
                return null;
              },
              decoration: InputDecoration(
                label: const Text("Username, Email or Mobile"),
                border: FormMaster.border(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwdcontroller,
              obscureText: true,
              enableSuggestions: false,
              validator: (value) {
                if (value == null) {
                  return "Required";
                }
                return null;
              },
              decoration: InputDecoration(
                  label: const Text("Password"), border: FormMaster.border()),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    Map<String, dynamic> user = {};
                    user['action'] = 'login';
                    user['user'] = {
                      "user": unamecontroller.text,
                      "passwd": passwdcontroller.text
                    };
                    roy4dApi.auth(user).then((value) {
                      if (value != null) {
                        LoginManager().saveLoginSession(context, value);
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging in...')),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      dobcontroller.text = pickedDate.toString().substring(0, 10);
    });
  }

  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lnamecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController dialcodecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pwdcontroller = TextEditingController();
  TextEditingController cpwdcontroller = TextEditingController();
  Widget signup() {
    return Form(
      key: signupFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: fnamecontroller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              label: const Text("First name"),
              border: FormMaster.border(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: lnamecontroller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              label: const Text("Last name"),
              border: FormMaster.border(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: dialcodecontroller,
                  onTap: () {
                    roy4dApi.showCountryBottomSheetSelector(
                        dialcodecontroller, countrycontroller);
                  },
                  decoration: InputDecoration(
                      hintText: "+1", suffixText: countrycontroller.text),
                  textAlign: TextAlign.center,
                  readOnly: true,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: mobilecontroller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: "000 000 000"),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: dobcontroller,
            onTap: () {
              selectDate();
            },
            decoration: InputDecoration(
              border: FormMaster.border(),
              label: const Text("Date of Birth"),
            ),
            readOnly: true,
            enableSuggestions: false,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailcontroller,
            decoration: InputDecoration(
                border: FormMaster.border(),
                label: const Text("Email Address")),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: pwdcontroller,
            decoration: InputDecoration(
              border: FormMaster.border(),
              label: const Text("Password"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: cpwdcontroller,
            decoration: InputDecoration(
              border: FormMaster.border(),
              label: const Text("Password"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (signupFormKey.currentState!.validate()) {
                  Map<String, dynamic> user = {};
                  user['action'] = 'registerUser';
                  user['user'] = {
                    "fname": fnamecontroller.text,
                    "lname": lnamecontroller.text,
                    "country": countrycontroller.text,
                    "mobile": mobilecontroller.text,
                    "dob": dobcontroller.text,
                    "email": emailcontroller.text,
                    "pwd": pwdcontroller.text,
                    "cpwd": cpwdcontroller.text
                  };
                  roy4dApi.auth(user).then((value) {
                    if (value != null) {
                      LoginManager().saveLoginSession(context, value);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging in...')),
                  );
                }
              },
              child: const Text("Signup"),
            ),
          )
        ],
      ),
    );
  }
}

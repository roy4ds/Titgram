import 'package:flutter/material.dart';
import 'package:titgram/incs/api/roy4d_api.dart';
import 'package:titgram/incs/utils/form_master.dart';

class LoginForms {
  final BuildContext context;
  LoginForms(this.context);

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
              },
              decoration: InputDecoration(
                label: const Text("Username | Email | Mobile"),
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
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    Map<String, String> user = {};
                    user['action'] = 'login';
                    Roy4dApi(context).auth(user);
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
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      dobcontroller.text = pickedDate.toString();
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
          TextFormField(
            controller: lnamecontroller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              label: const Text("First name"),
              border: FormMaster.border(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              TextFormField(
                controller: dialcodecontroller,
                decoration: const InputDecoration(hintText: "+1"),
                readOnly: true,
              ),
              const SizedBox(
                width: 8,
              ),
              TextFormField(
                controller: mobilecontroller,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: dobcontroller,
            onTap: () {
              _restorableDatePickerRouteFuture.present();
            },
            decoration: InputDecoration(
                border: FormMaster.border(),
                label: const Text("Date of Birth")),
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
            child: ElevatedButton(
              onPressed: () {
                if (signupFormKey.currentState!.validate()) {
                  Map<String, String> user = {};
                  user['fname'] = fnamecontroller.text;
                  user['lname'] = lnamecontroller.text;
                  user['country'] = countrycontroller.text;
                  user['mobile'] = mobilecontroller.text;
                  user['dob'] = 'registerUser';
                  user['email'] = 'registerUser';
                  user['pwd'] = 'registerUser';
                  user['cpwd'] = 'registerUser';
                  user['action'] = 'registerUser';
                  Roy4dApi(context).auth(user);
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

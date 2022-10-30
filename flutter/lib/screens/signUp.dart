
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:testapp/utils/APIHandler.dart';

import '../utils/APIHandler.dart';
import 'home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var email = "";
  var password = "";
  String buttonText = "Sign Up";
  final signUpForm = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final APIhandler _apiHandler = APIhandler();

  Future<void> _handleSignUp()async {
    if (signUpForm.currentState!.validate()) {
      setState(() {
        buttonText = "Processing";
      });
      Map<String,dynamic> userData = {
        "email":emailController.text,
        "password":passwordController.text,
      };

      Map response = await _apiHandler.signUp(userData);
      if(response['status'] == 'success'){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
              (Route route) => false,
        );
      }
      else{
        LinkedHashMap data = response['data'];
        String message = "";
        data.forEach((key, value) {
          message+='$value\n';
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Create an account', style: TextStyle(fontSize: 22)),
        Form(
          key: signUpForm,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Email address',
                        prefixIcon: Icon(Icons.email_rounded)),
                    validator: (value) {
                      if (value != null &&
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return "Email address is not valid";
                      }
                      return null;
                    },
                    cursorColor: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.key_rounded)),
                    validator: (value) {
                      if (value != null && value.length < 8) {
                        return "Password needs to be between 8-16 characters";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Retype password',
                        prefixIcon: Icon(Icons.key_rounded)),
                    validator: (value) {
                      if (value != null && value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RawMaterialButton(
                      fillColor: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      onPressed: _handleSignUp,
                      constraints:
                          const BoxConstraints.tightFor(height: 50, width: 150),
                      child: Text(buttonText, style: const TextStyle(fontSize: 18)),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Already have an account?\nclick here!",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ))),
              ])),
        ),
      ],
    )));
  }
}

import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testapp/screens/signUp.dart';

import '../utils/APIHandler.dart';
import 'home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final loginForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var buttonText = "Log In";
  final APIhandler _apiHandler = APIhandler();

  Future<void> _handleLogIn()async {
    if (loginForm.currentState!.validate()) {
      setState(() {
        buttonText = "Logging In";
      });
      Map<String,dynamic> userData = {
        "email":_emailController.text,
        "password":_passwordController.text,
      };

      dynamic response = await _apiHandler.logIn(userData);

      if(response!=null && response['status'] == 'failure'){
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Credentials')));
      }
      else if(response!=null && response['status']=='success'){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
              (Route route) => false,
        );
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
        const Text('Entertainment System', style: TextStyle(fontSize: 22)),
        Form(
          key: loginForm,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value != null &&
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return "Email address is not valid";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Email address',
                        prefixIcon: Icon(Icons.email_rounded)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value != null && value.length < 8) {
                        return "Invalid Password";
                      }
                    },
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.key_rounded)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RawMaterialButton(
                      fillColor: Colors.green.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      onPressed: _handleLogIn,
                      constraints:
                          const BoxConstraints.tightFor(height: 50, width: 150),
                      child:
                          const Text('Log In', style: TextStyle(fontSize: 18)),

                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const SignUpPage()));
                        },
                        child: const Text(
                          "Don't have an account?\nclick here!",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ))),
              ])),
        ),
      ],
    )));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:testapp/screens/home.dart';

import 'package:testapp/utils/APIHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),_startApp);
    super.initState();
  }

  Future<void> _startApp() async {
    final storage = FlutterSecureStorage();
    String? loginStatus = await storage.read(key: "loginStatus");
    if (loginStatus == 'true') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
            (Route route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
            (Route route) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade300,
        body: const Center(
          child: Text("Entertainment\nSystem",style: TextStyle(fontSize: 32,color: Colors.white,fontWeight:FontWeight.bold))
        ));
  }
}

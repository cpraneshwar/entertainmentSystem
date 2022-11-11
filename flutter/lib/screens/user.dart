import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';
import 'package:testapp/screens/quiz.dart';

import 'package:testapp/utils/APIHandler.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String email = "Default User";
  late int points = 0;
  late double rewardProgress = 0;
  late int rewardPoints = 0;
  late AnimationController controller;
  final APIhandler _apiHandler = APIhandler();
  @override
  void initState() {
    _fillUserDetails();
    super.initState();
  }

  void _handleLogOut() {
    const storage = FlutterSecureStorage();
    storage.write(key: 'token', value: null);
    storage.write(key: 'loginStatus', value: 'false');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
          (Route route) => false,
    );
    //TODO: Handle logout logic
  }

  Future<void> _fillUserDetails() async {
    const storage = FlutterSecureStorage();
    Map response = await _apiHandler.getUser();

    String em = await storage.read(key: 'email') as String;
    if (response['status'] == "failure") {
      _handleLogOut();
    } else {
      setState(() {
        rewardPoints = response['data']['reward_points'];
        rewardProgress = 0.4;
        email = em;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () {
                _handleLogOut();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Log out',
              onPressed: () {
                _handleLogOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Row(children: [
              const Icon(Icons.person, size: 80.0),
              Column(children: [
                Text(email),
                Text("Reward Points: $rewardPoints"),
              ])
            ])
          ],
        ));
  }
}

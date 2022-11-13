import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';
import 'package:testapp/screens/quiz.dart';

import 'package:testapp/utils/APIHandler.dart';

import 'home.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<StatefulWidget> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
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

  void _openHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const HomePage(),
      ),
      (Route route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFB73E3E),
          title: const Text("Redeem Rewards"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [Text("Redeem your points here"),

          ],
        ));
  }

  Widget imageCard(String label, String imageURL, dynamic onClick) {
    return Container(
        constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
        child: Card(
            child: InkWell(
              onTap: onClick,
              child: Column(children: [
                Image.asset(imageURL),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Center(child: Text(label)),
                )
              ]),
            )));
  }
}

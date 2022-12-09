import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';
import 'package:testapp/screens/quiz.dart';
import 'package:testapp/screens/quizhome.dart';
import 'package:testapp/screens/user.dart';

import 'package:testapp/utils/APIHandler.dart';

import '../utils/PushNotif.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  late String email = "Default User";
  late int points = 0;
  late double rewardProgress = 0;
  late int rewardPoints = 0;
  late AnimationController controller;
  final APIhandler _apiHandler = APIhandler();
  static late final FirebaseMessaging _firebaseMessaging;
  @override
  void initState() {
    Firebase.initializeApp();
    _fillUserDetails();

    super.initState();
  }

  void _handleLogOut() {
    const storage = FlutterSecureStorage();
    storage.write(key: 'token', value: null);
    storage.write(key: 'loginStatus', value: 'false');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
      (Route route) => false,
    );
    //TODO: Handle logout logic
  }

  Future<void> _fillUserDetails() async {
    const storage = FlutterSecureStorage();
    Map response = await _apiHandler.getUser();

    _firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    print(fcmToken);
    _apiHandler.uploadDeviceID(fcmToken!);
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
  void _openUser() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const UserPage(),
      ),
      (Route route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFFB73E3E),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_rounded),
                tooltip: 'Account',
                onPressed: () {
                  _openUser();
                },
              ),
            ],
            title: const Text("Home")),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                height: 80,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFBCE0FF),
                    Color(0xFFDBFFE6),
                  ],
                ),
                borderRadius: BorderRadius.circular(5)
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                    onTap: _openQuiz,
                    child: module("Quiz", null)))
          ],
        ));
  }

  Widget module(title, image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        const Icon(
          Icons.arrow_right_alt,
          size: 35,
        )
        //Center(child: imageCard("Music", "assets/images/quiz.png",_openQuiz))
      ],
    );
  }

  void _openQuiz() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const QuizHomePage(),
      ),
      (Route route) => false,
    );
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

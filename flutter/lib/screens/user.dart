import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';
import 'package:testapp/screens/quiz.dart';
import 'package:testapp/screens/rewards.dart';

import 'package:testapp/utils/APIHandler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'home.dart';

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
  late String linkURL = "";
  late AnimationController controller;
  late bool cal_connected = false;
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
      bool connected = response['data']['cal_connected'];
      if(!cal_connected){
        linkURL = await getLinkURL();
      }
      setState(() {
        rewardPoints = response['data']['reward_points'];
        cal_connected = connected;
        rewardProgress = 0.4;
        email = em;
      });
    }
  }

  Future<String> getLinkURL() async {
    String linkURL = await _apiHandler.getLinkURL();
    print(linkURL);
    return linkURL;
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
          title: const Text("User Account"),
          leading: IconButton(
            icon: const Icon(Icons.home_rounded),
            tooltip: 'Home',
            onPressed: () {
              _openHome();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () {
                _fillUserDetails();
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
            Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: [
              const Icon(Icons.person, size: 80.0),
              Column(children: [
                Text(email),
                Text("Reward Points: $rewardPoints"),
              ]),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => RewardPage(points: rewardPoints))).then((value) => _fillUserDetails())
                        },
                    child: Text("Redeem Points")),
                  ElevatedButton(
                      onPressed: cal_connected?null:()=>_openBrowser(),
                      child: cal_connected?Text("Calendar Linked"):Text("Link Outlook Calendar"))
                ]
            )
          ],
        ));
  }

  void _openBrowser() async {
    print(linkURL);
    var uri = Uri.parse(linkURL);
    var urllaunchable = await canLaunchUrl(uri); //canLaunch is from url_launcher package
    if(urllaunchable){
      await launchUrl(uri); //launch is from url_launcher package to launch URL
    }else{
      print("URL can't be launched.");
    }
  }

}

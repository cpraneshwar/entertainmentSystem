import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';
import 'package:testapp/screens/quiz.dart';

import 'package:testapp/utils/APIHandler.dart';

import 'home.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key, required this.points});

  final int points;
  @override
  State<StatefulWidget> createState() => _RewardPageState(points);
}

class _RewardPageState extends State<RewardPage> {
  late String email = "Default User";
  late double rewardProgress = 0;
  late int rewardPoints = 0;
  late AnimationController controller;
  final APIhandler _apiHandler = APIhandler();
  int points;

  _RewardPageState(this.points);
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
        body: SingleChildScrollView(
            child:Column(
          children: [
            Container(
                padding: EdgeInsets.all(15),
                child: Text("You currently have $points points",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400))),
            module("title", "image")
          ],
        )));
  }

  Widget module(title, image) {
    return Column(children: [
      Container(
          decoration: const BoxDecoration(
              border: Border(
            top: BorderSide(color: Colors.blueGrey),
            right: BorderSide(color: Colors.blueGrey),
            left: BorderSide(color: Colors.blueGrey),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child:
                      imageCard("Osmow's", "assets/images/osmows.png", null)),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("1000 points = 10\$",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen.shade700),
                        onPressed: (points > 1000) ? () => buttonPress(1000) : null,
                        child: (points > 1000)
                            ? Text("Redeem Points")
                            : Text("Not enough points")),
                  ])
            ],
          )),
      Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child: imageCard("Costco", "assets/images/costco.png", null)),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("2000 points = 20\$",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen.shade700),
                        onPressed: (points > 2000) ? () => buttonPress(2000) : null,
                        child: (points > 2000)
                            ? Text("Redeem Points")
                            : Text("Not enough points")),
                  ])
            ],
          ))
    ]);
  }

  void _redeemReward(point) async {
    Navigator.pop(context, 'Sure');
    var response = await _apiHandler.removePoints(point);
    setState(() {
      points = response['data']['reward_points'];
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('An email will be sent with the coupon soon!'),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    ));

  }

  void buttonPress(points) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: const Text(
            'Are you sure you want to redeem your points for the coupon?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _redeemReward(points),
            child: const Text('Sure'),
          ),
        ],
      ),
    );
  }

  Widget imageCard(String label, String imageURL, dynamic onClick) {
    return Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(maxHeight: 150, maxWidth: 150),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: InkWell(
          onTap: onClick,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(imageURL)]),
        ));
  }
}

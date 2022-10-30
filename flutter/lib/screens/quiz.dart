import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';

import 'package:testapp/utils/APIHandler.dart';

import 'home.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<StatefulWidget> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  final APIhandler _apiHandler = APIhandler();
  @override
  void initState() {
    super.initState();
  }


  void _openHome(){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      ),
          (Route route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          leading:
            IconButton(
              icon: const Icon(Icons.home_rounded),
              tooltip: 'Home',
              onPressed: () {
                _openHome();
              },
            ),
        ),
        body: Column(
          children: [
            Row(children: [const Icon(Icons.person, size: 80.0), Text("Test")]),
            Column(
              children: [
                Center(
                    child: imageCard("Quiz", "assets/images/quiz.png")
                )
              ],
            )
          ],
        ));
  }

  Widget imageCard(String label, String imageURL){
    return Card(
      child: Column(children: [
        Image.asset(imageURL),
        SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text(label)),
        )
      ]),
    );
  }
}

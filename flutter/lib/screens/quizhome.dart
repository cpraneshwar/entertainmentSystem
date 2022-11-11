import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/screens/login.dart';
import 'package:testapp/screens/quiz.dart';

import 'package:testapp/utils/APIHandler.dart';

import 'home.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _QuizHomePageState();
}

class Quiz {
  String category;
  int categoryID;

  Quiz(this.categoryID, this.category);
}

class _QuizHomePageState extends State<QuizHomePage> {
  late String email = "Default User";
  late int points = 0;
  late double rewardProgress = 0;
  late int rewardPoints = 0;
  late AnimationController controller;

  List<Quiz> categData = <Quiz>[];

  @override
  void initState() {
    categData.add(Quiz(9, "General Knowledge"));
    categData.add(Quiz(23, "History"));
    categData.add(Quiz(17, "Science"));
    categData.add(Quiz(27, "Animals"));
    categData.add(Quiz(11, "Movies"));
    categData.add(Quiz(10, "Books"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> quizList = <Widget>[];
    for (Quiz quiz in categData) {
      quizList.add(ElevatedButton(
          onPressed: () => _openQuiz(quiz.categoryID, "medium"),
          child: Text(quiz.category)));
    }
    void _openHome() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        ),
        (Route route) => false,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz"),
          leading: IconButton(
            icon: const Icon(Icons.home_rounded),
            tooltip: 'Home',
            onPressed: () {
              _openHome();
            },
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [Center(child: Column(children: quizList))],
            )));
  }

  void _openQuiz(int category, String difficulty) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            QuizPage(category: category, difficulty: difficulty),
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

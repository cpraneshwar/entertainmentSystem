import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:testapp/screens/quizhome.dart';

import 'package:testapp/utils/APIHandler.dart';

class QuizEndPage extends StatefulWidget {
  const QuizEndPage({super.key, required this.score, required this.category, required this.difficulty});

  final int score;
  final int category;
  final int difficulty;
  @override
  State<StatefulWidget> createState() => _QuizEndPageState(score,category,difficulty);
}

class _QuizEndPageState extends State<QuizEndPage> {
  final APIhandler _apiHandler = APIhandler();
  final int _totalQuestions = 10;
  int score;
  int category;
  int difficulty;
  int multiplier=5;
  bool fetched = false;
  late List quizData;

  _QuizEndPageState(this.score,this.category,this.difficulty);
  @override
  void initState() {
    super.initState();
    if(difficulty==1){
      multiplier=10;
    }
    else if(difficulty==2){
      multiplier=20;
    }
    multiplier=score*multiplier;
    _sendQuizData();
  }

  void _sendQuizData(){
    _apiHandler.uploadQuizData(score,10,difficulty,category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFFB73E3E),title: const Text("Home")),
        body: Container(padding: EdgeInsets.all(20), child: quizContent()));
  }


  Widget quizContent() {
      return Column(children: [
        Text("Your score",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        CircularPercentIndicator(
          radius: 50.0,
          animation: true,
          animationDuration: 250,
          lineWidth: 10.0,
          percent: score / _totalQuestions,
          center: Text(
            "$score/$_totalQuestions",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.yellow,
          progressColor: Colors.green,
        ),
        Text("You earned $multiplier points",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        Container(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    textStyle:
                    MaterialStateProperty.all(const TextStyle(color: Colors.white)),
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () => _openHome(),
                child: const Text("Back to Quiz Home"),
              ),
            ))
      ]);

  }

  void _openHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const QuizHomePage(),
      ),
          (Route route) => false,
    );
  }

}

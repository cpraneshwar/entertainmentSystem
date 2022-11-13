import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:testapp/screens/quizhome.dart';

import 'package:testapp/utils/APIHandler.dart';

import 'home.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.category, required this.difficulty});

  final int category;
  final String difficulty;

  @override
  State<StatefulWidget> createState() => _QuizPageState(category, difficulty);
}

class _QuizPageState extends State<QuizPage> {
  final APIhandler _apiHandler = APIhandler();
  final int _totalQuestions = 10;
  int _currentQuestion = 1;
  String _correctAnswer = "";
  int rng = 0;
  int score = 0;
  int category;
  String difficulty;
  bool fetched = false;
  late List quizData;

  _QuizPageState(this.category, this.difficulty);
  @override
  void initState() {
    _initQuiz();
    super.initState();
  }

  void _initQuiz() {
    _apiHandler.getQuizData(category, difficulty).then((response) {
      setState(() {
        fetched = true;
        quizData = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFFB73E3E),title: const Text("Home")),
        body: Container(padding: EdgeInsets.all(20), child: quizContent()));
  }

  Widget imageCard(String label, String imageURL) {
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

  Widget quizContent() {
    if (!fetched) {
      return Container(child: Text("Quiz is being loaded"));
    } else {
      print(quizData);
      List currentQuiz = quizData;
      String question = currentQuiz[_currentQuestion - 1]['question'];
      List answers = currentQuiz[_currentQuestion - 1]['incorrect_answers'];
      rng = Random().nextInt(3);
      _correctAnswer = currentQuiz[_currentQuestion - 1]['correct_answer'];
      answers.insert(rng, _correctAnswer);
      return Column(children: [
        CircularPercentIndicator(
          radius: 50.0,
          animation: false,
          animationDuration: 100,
          lineWidth: 10.0,
          percent: _currentQuestion / _totalQuestions,
          center: Text(
            "$_currentQuestion/$_totalQuestions",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.yellow,
          progressColor: Colors.green,
        ),
        Container(
            padding: EdgeInsets.all(20),
            child: Text(
              question,
              style: TextStyle(fontSize: 24),
            )),
        quizOption(answers[0]),
        quizOption(answers[1]),
        quizOption(answers[2]),
        quizOption(answers[3])
      ]);
    }
  }

  void _answerQuestion(String text) {
    print(text);
    if (text == _correctAnswer) {
      score += 10;
    }
    if (_currentQuestion == 10) {
      print(score);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const QuizHomePage(),
        ),
        (Route route) => false,
      );
    } else {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  Widget quizOption(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            textStyle:
                MaterialStateProperty.all(const TextStyle(color: Colors.white)),
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
        onPressed: () => _answerQuestion(text),
        child: Text(text),
      ),
    );
  }
}

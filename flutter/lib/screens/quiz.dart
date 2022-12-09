import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:testapp/screens/quizend.dart';
import 'package:testapp/screens/quizhome.dart';

import 'package:testapp/utils/APIHandler.dart';

import 'home.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.category, required this.difficulty});

  final int category;
  final int difficulty;

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
  int difficulty;
  bool fetched = false;
  bool answered = false;
  int selected=-1;
  late List quizData;
  Color correctColor = Colors.blue;
  List answers = [];
  String question = "";

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
        appBar: AppBar(
            backgroundColor: Color(0xFFB73E3E), title: const Text("Home")),
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
      return CircularPercentIndicator(
        radius: 25.0,
        animation: true,
        animationDuration: 250,
        lineWidth: 5.0,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: Colors.blue,
        progressColor: Colors.lightBlue,
      );
    } else {
      if(selected==-1) {
        List currentQuiz = quizData;
        question = currentQuiz[_currentQuestion - 1]['question'];
        question = question.replaceAll("&quot;", "\'");
        question = question.replaceAll("&#039;", "\'");
        answers = List.from(currentQuiz[_currentQuestion - 1]['incorrect_answers']);
        rng = Random().nextInt(3);
        _correctAnswer = currentQuiz[_currentQuestion - 1]['correct_answer'];
        answers.insert(rng, _correctAnswer);
        List filtered = [];
        for (var element in answers) {
          String filter = element.replaceAll("&quot;", "\'");
          filter = filter.replaceAll("&#039;", "\'");
          filtered.add(filter);
        }
        answers = filtered;
      }
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
        quizOption(answers[0], 0),
        quizOption(answers[1], 1),
        quizOption(answers[2], 2),
        quizOption(answers[3], 3)
      ]);
    }
  }

  void _answerQuestion(String text,int index) {
    setState(() {
      answered = true;
      selected=index;
    });
    if (text == _correctAnswer) {
      score += 1;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      answered = false;
      selected=-1;
      if (_currentQuestion == 10) {
        print(score);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                QuizEndPage(score: score, category: category,difficulty: difficulty),
          ),
          (Route route) => false,
        );
      } else {
        setState(() {
          _currentQuestion++;
        });
      }
    });
  }

  Widget quizOption(String text, int index) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            textStyle:
                MaterialStateProperty.all(const TextStyle(color: Colors.white)),
            backgroundColor: (answered)?((index == rng)
                ? MaterialStateProperty.all(Colors.lightGreen)
                : (index == selected)?MaterialStateProperty.all(Colors.redAccent):MaterialStateProperty.all(Colors.blueAccent)):(MaterialStateProperty.all(Colors.blue))),
        onPressed: () => _answerQuestion(text,index),
        child: Text(text),
      ),
    );
  }
}

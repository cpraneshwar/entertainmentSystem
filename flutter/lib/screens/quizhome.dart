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
  int _value = 0;

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

  Widget module(title, image) {
        return Center(child:Text(title,textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)));
    }

  @override
  Widget build(BuildContext context) {
    List<Widget> quizList = <Widget>[];
    Widget content = Text("asdasd");
    categData.asMap().forEach((index, element) {
      Quiz quiz = element;
      if (index % 2 == 0) {
        content = Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            height: 150,
            width: 150,
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
                onTap: () => _openQuiz(quiz.categoryID,_value),
                child: module(quiz.category, null)));
      } else {
        quizList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            content,
            content = Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFDBFFE6),
                        Color(0xFFBCE0FF)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openQuiz(quiz.categoryID,_value),
                    child: module(quiz.category, null)))
          ],
        ));
      }
    });
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
          backgroundColor: Color(0xFFB73E3E),
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
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(
              3,
                  (int index) {
                return ChoiceChip(
                  label: Text(index==0?"Easy":index==1?"Medium":"Hard"),
                  selectedColor: Colors.lightGreen.shade100,

                  selected: _value == index,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = (selected ? index : null)!;
                    });
                  },
                );
              },
            ).toList(),
        )
                ,Center(child: Column(children: quizList))],
            )));
  }

  void _openQuiz(int category, int difficulty) {
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

import 'package:flutter/material.dart';
import 'package:quize_app/model/model_quiz.dart';
import 'package:quize_app/model/quiz.dart';
import 'package:quize_app/screen/screen_result.dart';
import 'package:quize_app/widget/widget_candidate.dart';

class QuizeScreen extends StatefulWidget {
  List<QuizModel> quizs;
  QuizeScreen({required this.quizs});

  @override
  _QuizeScreenState createState() => _QuizeScreenState();
}

class _QuizeScreenState extends State<QuizeScreen> {
  List<int> _answers = [-1, -1];
  List<bool> _answersStates = [false, false];
  int _currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Center(
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.yellowAccent)),
        width: width * 0.85,
        height: height * 0.5,
        child: PageView.builder(
          pageSnapping: true,
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          itemBuilder: (BuildContext context, int index) {
            return _buildQuizCard(widget.quizs[index], width, height);
          },
          itemCount: widget.quizs.length,
        ),
      )),
    ));
  }

  Widget _buildQuizCard(QuizModel quizs, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
            child: Text(
              'Q' + (_currentIndex + 1).toString() + '.',
              style: TextStyle(
                  fontSize: width * 0.06, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: Text(quizs.quiz.toString()),
          ),
          Expanded(
            child: Container(),
          ),
          Column(children: _buildCandidates(width, quizs)),
          Container(
              padding: EdgeInsets.all(width * 0.024),
              child: Center(
                child: ButtonTheme(
                    minWidth: width * 0.8,
                    height: width * 0.07,
                    child: ElevatedButton(
                      child: _currentIndex == widget.quizs.length - 1
                          ? Text("결과보기")
                          : Text("다음문제"),
                      onPressed: _answers[_currentIndex] == -1
                          ? null
                          : () {
                              if (_currentIndex == widget.quizs.length - 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                              answers: _answers,
                                              quizs: widget.quizs,
                                            )));
                              } else {
                                _answersStates = [false, false, false, false];
                                _currentIndex += 1;
                                pageController.jumpToPage(_currentIndex);
                              }
                            },
                    )),
              ))
        ],
      ),
    );
  }

  List<Widget> _buildCandidates(double width, QuizModel quiz) {
    List<Widget> _children = [];
    for (int i = 0; i < widget.quizs.length; i++) {
      _children.add(CandWidget(
        index: i,
        text: quiz.answer?[i - 1],
        width: width,
        answerState: _answersStates[i],
        tap: () {
          setState(() {
            for (int j = 0; j < 4; j++) {
              if (j == i) {
                _answersStates[j] = true;
                _answers[_currentIndex] = j;
              } else {
                _answersStates[j] = false;
              }
            }
          });
        },
      ));
      _children.add(Padding(
        padding: EdgeInsets.all(width * 0.024),
      ));
    }
    return _children;
  }
}


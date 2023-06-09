import 'package:Edufy/screens/home_screen/home_screen.dart';
import 'package:Edufy/screens/quiz1/question_model.dart';
import 'package:Edufy/screens/quiz2/quiz_screen.dart';
import 'package:Edufy/screens/quiz3/question_model.dart';
import 'package:Edufy/screens/quiz4/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Edufy/screens/home_screen/globals.dart' as globals;
import 'dart:async'; // necessary for Timer
import 'package:flutter/foundation.dart';

class QuizScreen1 extends StatefulWidget {
  const QuizScreen1({Key? key}) : super(key: key);
  static const String routeName = 'QuizScreen1';

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen1> {
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void nextQuiz() {
    Navigator.pushReplacementNamed(context, QuizScreen4.routeName);
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            },
            child: Icon(Icons.logout),
          )
        ],
        title: Text('Back to Home'),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Simple Quiz App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            _questionWidget(),
            _answerList(),
            _nextButton(),
          ],
        ),
      ),
    );
  }

  Widget _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map((e) => _answerButton(e))
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected ? Colors.orangeAccent : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          if (selectedAnswer == null) {
            if (answer.isCorrect) {
              score++;
            }
            setState(() {
              selectedAnswer = answer;
            });
          }
        },
      ),
    );
  }

  Widget _nextButton() {
    bool isLastQuestion = currentQuestionIndex == questionList.length - 1;

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if (isLastQuestion) {
            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            setState(() {
              selectedAnswer = null;
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }

  Future<void> _saveQuizResult(double scorePercentage) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final quizResultRef = _firestore.collection('quizResults').doc(userId);
        await quizResultRef.set({'percentage': scorePercentage});
      }
    } catch (error) {
      print('Error saving quiz result: $error');
    }
  }

  Future<void> _awardCoins() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userRef = _firestore.collection('users').doc(userId);
        final userData = await userRef.get();
        final currentCoins = userData.data()?['coins'] ?? 0;
        final newCoins = currentCoins + 10;
        await userRef.update({'coins': newCoins});
      }
    } catch (error) {
      print('Error awarding coins: $error');
    }
  }

  Widget _showScoreDialog() {
    bool isPassed = false;
    double scorePercentage = (score / questionList.length) * 100;

    if (scorePercentage >= 60) {
      isPassed = true;
    }
    String title = isPassed ? "Passed" : "Failed";

    //   globals.isDisabled.value = true;  // setting a new value
    // globals.timer.value = 5;  // setting a new value

    // // Set a Timer to make isDisabled false after 1 minute
    // Timer(Duration(seconds: 5), () {
    //   globals.isDisabled.value = false;
    // });

    // NEW CODE

    globals.isDisabled.value = true; // setting a new value
    globals.timer.value = 60; // setting a new value to 60 seconds (1 minute)
    globals.quizDone.value = 1; // incrementing the value of quizDone by 1
// Set a Timer to decrement the timer every second
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (globals.timer.value > 0) {
        globals.timer.value -= 1;
      } else {
        // When the timer reaches zero, make isDisabled false
        globals.isDisabled.value = false;
        t.cancel(); // Remember to cancel the Timer when you don't need it anymore
      }
    });

    return AlertDialog(
      title: Text(
        '$title | Score: $scorePercentage%',
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: ElevatedButton(
        child: const Text("Home"),
        onPressed: () {
          _saveQuizResult(scorePercentage);
          _awardCoins();
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
          setState(() {
            currentQuestionIndex = 0;
            score = 0;
            selectedAnswer = null;
          });
        },
      ),
    );
  }
}

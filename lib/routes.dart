import 'package:Edufy/screens/quiz1/quiz_screen.dart';
import 'package:Edufy/screens/quiz2/quiz_screen.dart';
import 'package:Edufy/screens/quiz3/quiz_screen.dart';
import 'package:Edufy/screens/quiz4/quiz_screen.dart';
import 'package:Edufy/screens/quiz5/quiz_screen.dart';

import '/screens/login_screen/login_screen.dart';
import '/screens/notes/addNoteScreen.dart';
import '/screens/notes/editNoteScreen.dart';
import '/screens/notes/notes.dart';
import '/screens/register_screen/register_screen.dart';
import '/screens/splash_screen/splash_screen.dart';

import 'package:flutter/cupertino.dart';
import 'screens/assignment_screen/assignment_screen.dart';
import 'screens/datesheet_screen/datesheet_screen.dart';
import 'screens/fee_screen/fee_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  FeeScreen.routeName: (context) => FeeScreen(),
  AssignmentScreen.routeName: (context) => AssignmentScreen(),
  DateSheetScreen.routeName: (context) => DateSheetScreen(),
  QuizScreen1.routeName: (context) => QuizScreen1(),
  QuizScreen2.routeName: (context) => QuizScreen2(),
  QuizScreen3.routeName: (context) => QuizScreen3(),
  QuizScreen4.routeName: (context) => QuizScreen4(),
  QuizScreen5.routeName: (context) => QuizScreen5(),
  NotesScreen.routeName: (context) => NotesScreen(),
  AddNoteScreen.routeName: (context) => AddNoteScreen(),
  EditNoteScreen.routeName: (context) => EditNoteScreen(),
};

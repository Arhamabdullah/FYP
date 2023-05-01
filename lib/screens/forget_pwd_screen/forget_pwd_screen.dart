import 'dart:developer';

import '/components/custom_buttons.dart';
import '/constants.dart';
import '/screens/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

late bool _passwordVisible;

class ForgetPwdScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _ForgetPwdScreenState createState() => _ForgetPwdScreenState();
}

class _ForgetPwdScreenState extends State<ForgetPwdScreen> {
  //validate our form now
  final _formKey = GlobalKey<FormState>();

  //changes current state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  //Controllers - control input values
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //when user taps anywhere on the screen, keyboard hides
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: 100.w,
              height: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi Student',
                          style: Theme.of(context).textTheme.subtitle1),
                      Text('Sign in to continue',
                          style: Theme.of(context).textTheme.subtitle2),
                      sizedBox,
                    ],
                  ),
                  Image.asset(
                    'assets/images/splash.png',
                    height: 20.h,
                    width: 40.w,
                  ),
                  SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                decoration: BoxDecoration(
                  color: kOtherColor,
                  //reusable radius,
                  borderRadius: kTopBorderRadius,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sizedBox,
                        buildEmailField(),
                        sizedBox,
                        DefaultButton(
                          onPress: () async {
                            // if (_formKey.currentState!.validate()) {
                            //   Navigator.pushNamedAndRemoveUntil(context,
                            //       HomeScreen.routeName, (route) => false);
                            // }
                            var loginEmail = loginEmailController.text.trim();
                            var loginPassword =
                                loginPasswordController.text.trim();

                            try {
                              final User? firebaseUser = (await FirebaseAuth
                                      .instance
                                      .signInWithEmailAndPassword(
                                          email: loginEmail,
                                          password: loginPassword))
                                  .user;
                              if (firebaseUser != null) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    HomeScreen.routeName, (route) => false);
                              } else {
                                log("Please Enter valid Email and Password!");
                              }
                            } on FirebaseAuthException catch (e) {
                              log("Error $e");
                            }
                          },
                          title: 'FORGOT PASSWORD',
                          iconData: Icons.arrow_forward_outlined,
                        ),
                        sizedBox,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: loginEmailController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        //for validation
        RegExp regExp = new RegExp(emailPattern);
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
          //if it does not matches the pattern, like
          //it not contains @
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
    );
  }
}

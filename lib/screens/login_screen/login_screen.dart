import 'dart:developer';
import 'package:Edufy/screens/forget_pwd_screen/forget_pwd_screen.dart';
import '/components/custom_buttons.dart';
import '/constants.dart';
import '/screens/home_screen/home_screen.dart';
import '/screens/register_screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                        buildPasswordField(),
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
                              if (firebaseUser != null &&
                                  _formKey.currentState!.validate()) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    HomeScreen.routeName, (route) => false);
                              } else {
                                log("Please Enter valid Email and Password!");
                              }
                            } on FirebaseAuthException catch (e) {
                              log("Error $e");
                            }
                          },
                          title: 'SIGN IN',
                          iconData: Icons.arrow_forward_outlined,
                        ),
                        sizedBox,
                        // Align(
                        //   alignment: Alignment.bottomRight,
                        //   child: Text(
                        //     'Forgot Password',
                        //     textAlign: TextAlign.end,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .subtitle2!
                        //         .copyWith(
                        //             color: kPrimaryColor,
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w600,
                        //             decoration: TextDecoration.underline),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                ForgotPasswordScreen.routeName,
                                (route) => true);
                          },
                          child: Text(
                            'Forgot Password',
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline),
                          ),
                        ),
                        sizedBox,
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'OR',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: kContainerColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w100),
                          ),
                        ),
                        sizedBox,
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Don't have an account?",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: kTextBlackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                        sizedBox,
                        DefaultButton(
                          onPress: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RegisterScreen.routeName, (route) => false);
                          },
                          title: 'CREATE AN ACCOUNT',
                          iconData: Icons.arrow_forward_outlined,
                        ),
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
        labelStyle: TextStyle(
          color: Color(0xFF777777),
        ),
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

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: loginPasswordController,
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Color(0xFF777777),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_off_outlined,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      validator: (value) {
        if (value!.length < 5) {
          return 'Must be more than 5 characters';
        }
      },
    );
  }
}

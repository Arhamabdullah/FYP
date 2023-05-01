// ignore_for_file: unused_local_variable

import 'dart:developer';

import '/components/custom_buttons.dart';
import '/constants.dart';
import '/screens/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/Signup.dart';

late bool _passwordVisible;

class RegisterScreen extends StatefulWidget {
  static String routeName = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? currentuser = FirebaseAuth.instance.currentUser;

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
                      Text('Register to continue',
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
                        buildNameField(),
                        sizedBox,
                        buildPhoneField(),
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
                            var name = nameController.text.trim();
                            var phone = phoneController.text.trim();
                            var email = emailController.text.trim();
                            var password = passwordController.text.trim();

                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password)
                                .then((value) => {
                                      signUpUser(name, phone, email, password),
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          LoginScreen.routeName,
                                          (route) => false),
                                      log("Account Created Successfully!"),
                                    });
                          },
                          title: 'REGISTER',
                          iconData: Icons.arrow_forward_outlined,
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
                            'Already have an account?',
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
                                LoginScreen.routeName, (route) => false);
                          },
                          title: 'SIGN IN',
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

  TextFormField buildNameField() {
    return TextFormField(
      controller: nameController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.name,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Name',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        //for validation
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
          //if it does not matches the pattern, like
          //it not contains @
        } else {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  TextFormField buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.number,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Phone',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        //for validation
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
          //if it does not matches the pattern, like
          //it not contains @
        } else {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: emailController,
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

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Password',
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

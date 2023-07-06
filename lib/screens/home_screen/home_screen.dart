import 'package:Edufy/screens/quiz1/quiz_screen.dart';
import '/constants.dart';
import '/screens/datesheet_screen/datesheet_screen.dart';
import '/screens/login_screen/login_screen.dart';
import '/screens/fee_screen/fee_screen.dart';
import '/screens/my_profile/my_profile.dart';
import '/screens/notes/notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'widgets/student_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance; // Initialize FirebaseAuth instance

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut(); // Use _auth to sign out
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false);
            },
            child: Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          // First Half of the Screen
          Container(
            width: 100.w,
            height: 40.h,
            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final userData = snapshot.data!.data();
                                final String admissionClass =
                                    userData?['admission_class'] ?? 'N/A';
                                return Column(
                                  children: [
                                    StudentName(
                                      studentName: 'Student',
                                    ),
                                    kHalfSizedBox,
                                    StudentClass(
                                        studentClass: 'Class $admissionClass'),
                                    kHalfSizedBox,
                                    StudentYear(studentYear: '2023'),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    StudentName(
                                      studentName: 'Student',
                                    ),
                                    kHalfSizedBox,
                                    StudentClass(
                                        studentClass:
                                            'Class N/A | Reg no: N/A'),
                                    kHalfSizedBox,
                                    StudentYear(studentYear: '2023'),
                                  ],
                                );
                              }
                            },
                          ),
                        ]),
                    kHalfSizedBox,
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userData = snapshot.data!.data();
                          final String gender = userData?['gender'] ?? '';
                          final String picAddress = getProfileImage(gender);
                          return StudentPicture(
                            picAddress: picAddress,
                            onPress: () {
                              Navigator.pushNamed(
                                  context, MyProfileScreen.routeName);
                            },
                          );
                        } else {
                          return StudentPicture(
                            picAddress: 'assets/images/student_profile.png',
                            onPress: () {
                              Navigator.pushNamed(
                                  context, MyProfileScreen.routeName);
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
                sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userData = snapshot.data!.data();
                          final int coins = userData?['coins'] ?? 0;
                          return StudentDataCard(
                            onPress: () {
                              Navigator.pushNamed(context, FeeScreen.routeName);
                            },
                            title: 'Coins',
                            value: coins.toString(),
                          );
                        } else {
                          return StudentDataCard(
                            onPress: () {
                              Navigator.pushNamed(context, FeeScreen.routeName);
                            },
                            title: 'Coins',
                            value: 'N/A',
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          // Second Half of the Screen
          Expanded(
            child: Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: kOtherColor,
                borderRadius: kTopBorderRadius,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                QuizScreen1.routeName, (route) => false);
                          },
                          icon: 'assets/icons/quiz.svg',
                          title: 'Activity',
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                NotesScreen.routeName, (route) => false);
                          },
                          icon: 'assets/icons/holiday.svg',
                          title: 'Notes',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/lock.svg',
                          title: 'Change\nPassword',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                LoginScreen.routeName, (route) => false);
                          },
                          icon: 'assets/icons/logout.svg',
                          title: 'Logout',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.title,
  }) : super(key: key);
  final VoidCallback onPress;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              width: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              color: kOtherColor,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}

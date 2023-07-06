import 'package:Edufy/constants.dart';
import 'package:Edufy/screens/PaymentDetailsScreen/PaymentDetailsScreen.dart';
import 'package:Edufy/screens/login_screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeeScreen extends StatelessWidget {
  const FeeScreen({Key? key}) : super(key: key);
  static String routeName = 'FeeScreen';

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false);
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final coins = data['coins'] ?? 0;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Coins: $coins',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  FeeButton(
                    title: 'Withdraw Now',
                    iconData: Icons.download_outlined,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentDetailsScreen()),
                      );
                    },
                    textColor: Colors.white,
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class FeeButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPress;
  final Color textColor;

  const FeeButton({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onPress,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress,
      icon: Icon(iconData),
      label: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            vertical: kDefaultPadding,
            horizontal: kDefaultPadding * 2,
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'PaymentSuccessScreen.dart';

class PaymentDetailsScreen extends StatefulWidget {
  static const String routeName = 'PaymentDetailsScreen';
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String _numberOfCoins = '';
  String _accountNumber = '';
  String _bankName = '';
  String _password = '';

  final _auth = FirebaseAuth.instance;

  void _validatePassword() async {
    // Perform password validation using Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(
            _auth.currentUser!.uid) // Replace 'user_id' with the actual user ID
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        String savedPassword = "pass";

        if (_password == savedPassword) {
          _savePaymentDetails();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(),
              ));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid Password'),
                content: Text('Please enter a valid password.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User Data Error'),
              content: Text('Error occurred while retrieving user data.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Not Found'),
            content: Text('User data not found.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _savePaymentDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(
            _auth.currentUser!.uid) // Replace 'user_id' with the actual user ID
        .update({
      'numberOfCoins': _numberOfCoins,
      'accountNumber': _accountNumber,
      'bankName': _bankName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment Details'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Number of Coins'),
                onChanged: (value) {
                  setState(() {
                    _numberOfCoins = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Account Number'),
                onChanged: (value) {
                  setState(() {
                    _accountNumber = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Bank Name'),
                onChanged: (value) {
                  setState(() {
                    _bankName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Enter Password'),
                        content: TextField(
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _validatePassword();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Pay Now'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

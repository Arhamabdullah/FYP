import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

signUpUser(String name, String phone, String email, String password) async {
  User? userId = FirebaseAuth.instance.currentUser;

  try {
    await FirebaseFirestore.instance.collection("user").doc(userId!.uid).set({
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'id': userId.uid,
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
        });
  } on FirebaseAuthException catch (e) {
    log("Error $e");
  }
}

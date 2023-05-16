import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signUpUser(
  String name,
  String phone,
  String email,
  String password,
  String fatherFirstName,
  String fatherLastName,
  String motherFirstName,
  String motherLastName,
  String gender,
) async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userData = {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'father_first_name': fatherFirstName,
        'father_last_name': fatherLastName,
        'mother_first_name': motherFirstName,
        'mother_last_name': motherLastName,
        'gender': gender,
        'id': user.uid,
      };

      final userRef =
          FirebaseFirestore.instance.collection('user').doc(user.uid);
      await userRef.set(userData);

      await FirebaseAuth.instance.signOut();
    }
  } on FirebaseAuthException catch (e) {
    log("Error: $e");
  } catch (e) {
    log("Error: $e");
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'notes.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});
  static const String routeName = 'AddNoteScreen';

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController addNoteController = TextEditingController();
  User? userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, NotesScreen.routeName, (route) => false);
            },
            child: Icon(Icons.logout),
          )
        ],
        title: Text('Create Note'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: [
          Container(
            child: TextFormField(
              controller: addNoteController,
              maxLines: null,
              decoration: InputDecoration(hintText: "Enter your notes here..."),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var note = addNoteController.text.trim();
              if (note != "") {
                try {
                  await FirebaseFirestore.instance
                      .collection("notes")
                      .doc()
                      .set({
                    "createdAt": DateTime.now(),
                    "note": note,
                    "userId": userId?.uid,
                  });
                } catch (e) {
                  log("Error $e");
                }
              }
            },
            child: Text('Add Note'),
          ),
        ]),
      ),
    );
  }
}

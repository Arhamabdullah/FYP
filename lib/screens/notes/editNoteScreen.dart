import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});
  static const String routeName = 'EditNoteScreen';

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Notes"),
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              controller: noteController
                ..text = "${Get.arguments['note'].toString()}",
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("notes")
                      .doc(Get.arguments['docId'].toString())
                      .update(
                    {
                      'note': noteController.text.trim(),
                    },
                  ).then((value) => {
                            log("Data Updated!"),
                          });
                },
                child: Text("Update"))
          ],
        ),
      ),
    );
  }
}

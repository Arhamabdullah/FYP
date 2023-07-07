import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);
  static const String routeName = 'NotesScreen';

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text('Notes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("userNotes")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final notes = snapshot.data?.docs ?? [];

          if (notes.isEmpty) {
            return Center(
              child: Text('No notes found'),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index].get('content');
              final title = notes[index].get('title');

              return ListTile(
                title: Text(title),
                subtitle: Text(note),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit Note'),
                              content: Column(
                                children: [
                                  TextField(
                                    controller: titleController..text = title,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                    ),
                                  ),
                                  TextField(
                                    controller: contentController..text = note,
                                    decoration: InputDecoration(
                                      labelText: 'Content',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final updatedTitle =
                                        titleController.text.trim();
                                    final updatedContent =
                                        contentController.text.trim();

                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(_auth.currentUser!.uid)
                                        .collection("userNotes")
                                        .doc(notes[index].id)
                                        .update({
                                      'title': updatedTitle,
                                      'content': updatedContent,
                                    }).then((value) {
                                      log("Note updated successfully!");
                                    }).catchError((error) {
                                      log("Error updating note: $error");
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(_auth.currentUser!.uid)
                            .collection("userNotes")
                            .doc(notes[index].id)
                            .delete()
                            .then((value) {
                          log("Note deleted successfully!");
                        }).catchError((error) {
                          log("Error deleting note: $error");
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Create Note'),
                content: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newTitle = titleController.text.trim();
                      final newContent = contentController.text.trim();

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(_auth.currentUser!.uid)
                          .collection("userNotes")
                          .add({
                        'title': newTitle,
                        'content': newContent,
                      }).then((value) {
                        log("Note created successfully!");
                      }).catchError((error) {
                        log("Error creating note: $error");
                      });

                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

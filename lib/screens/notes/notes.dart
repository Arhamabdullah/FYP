import 'package:Edufy/constants.dart';
import 'package:get/get.dart';

import '/screens/notes/addNoteScreen.dart';
import '/screens/notes/editNoteScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home_screen/home_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  static const String routeName = 'NoteScreen';

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
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
                  context, HomeScreen.routeName, (route) => false);
            },
            child: Icon(Icons.logout),
          )
        ],
        title: Text('Create Note'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("notes")
              .where("userId", isEqualTo: userId?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something Went Wrong!");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No Data Found!"));
            }
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var note = snapshot.data!.docs[index]['note'];
                  var userId = snapshot.data!.docs[index]['userId'];
                  var docId = snapshot.data!.docs[index].id;
                  return Card(
                    child: ListTile(
                      subtitle: Text(note),
                      title: Text(userId),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, EditNoteScreen.routeName,
                                  arguments: {
                                    'note': note,
                                    'docId': docId,
                                  });
                            },
                            child: Icon(Icons.edit),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection("notes")
                                  .doc(docId)
                                  .delete();
                            },
                            child: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AddNoteScreen.routeName, (route) => false);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

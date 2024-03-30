import 'package:chat_app/models/user.dart' as models;
import 'package:chat_app/repository/firestore_methods.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/widgets/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: StreamBuilder(
          stream: FirestoreMethods().getAllUsers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else {
              List<QueryDocumentSnapshot> userDocs = snapshot.data!.docs;
              List<QueryDocumentSnapshot> filteredUserDocs = [];
              //Filters users so that current user is not shown in home screen.
              for (var doc in userDocs) {
                if (doc.id != authenticatedUser.uid) {
                  filteredUserDocs.add(doc);
                }
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          user: models.User.fromSnap(
                            filteredUserDocs[index],
                          ),
                        ),
                      ),
                    ),
                    child: UserItem(
                      user: models.User.fromSnap(
                        filteredUserDocs[index],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.size - 1,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            }
          },
        ),
      ),
    );
  }
}

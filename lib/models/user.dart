import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String imageUrl;
  final String uid;

  User({
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.uid,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      imageUrl: snapshot['image_url'],
    );
  }
}

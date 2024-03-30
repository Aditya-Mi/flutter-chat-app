import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Class for Firestore Methods
class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  //Function to get current user from firebase
  User getCurrentUser() {
    return _firebaseAuth.currentUser!;
  }

  //Function to get unique group id for chat group between two users
  String _getGroupChatId(String currentId, String otherId) {
    List<String> ids = [currentId, otherId];
    ids.sort(); // Sort the IDs to ensure consistent group chat ID
    return ids.join('-');
  }

  //Function to get list of all students from firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firestore.collection('users').snapshots();
  }

  //Function to get all messaged of a chatgroup of two users from firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String currentUserId, required String peerUserId}) {
    return _firestore
        .collection('chat')
        .doc(_getGroupChatId(currentUserId, peerUserId))
        .collection(_getGroupChatId(currentUserId, peerUserId))
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //Function to add new message to firebae
  Future<void> newMessage(
      {required String message, required String peerUserID}) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser().uid)
        .get();
    FirebaseFirestore.instance
        .collection('chat')
        .doc(_getGroupChatId(user.data()!['uid'], peerUserID))
        .collection(_getGroupChatId(user.data()!['uid'], peerUserID))
        .add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.data()!['uid'],
      'username': user.data()!['username'],
      'userImage': user.data()!['image_url'],
    });
  }
}

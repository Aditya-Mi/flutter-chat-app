import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  User getCurrentUser() {
    return _firebaseAuth.currentUser!;
  }

  String getGroupChatId(String currentId, String otherId) {
    List<String> ids = [currentId, otherId];
    ids.sort(); // Sort the IDs to ensure consistent group chat ID
    return ids.join('-');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firestore.collection('users').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String currentUserId, required String peerUserId}) {
    return _firestore
        .collection('chat')
        .doc(getGroupChatId(currentUserId, peerUserId))
        .collection(getGroupChatId(currentUserId, peerUserId))
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> newMessage(
      {required String message, required String peerUserID}) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser().uid)
        .get();
    FirebaseFirestore.instance
        .collection('chat')
        .doc(getGroupChatId(user.data()!['uid'], peerUserID))
        .collection(getGroupChatId(user.data()!['uid'], peerUserID))
        .add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.data()!['uid'],
      'username': user.data()!['username'],
      'userImage': user.data()!['image_url'],
    });
  }
}

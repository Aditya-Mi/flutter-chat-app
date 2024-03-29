import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthMethods {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> login({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required File? image,
    required username,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final storageRef = _storage
        .ref()
        .child('user_images')
        .child('${userCredential.user!.uid}.jpg');
    await storageRef.putFile(image!);
    final imageUrl = await storageRef.getDownloadURL();
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'username': username,
      'email': email,
      'image_url': imageUrl,
      'uid': userCredential.user!.uid,
    });
  }
}

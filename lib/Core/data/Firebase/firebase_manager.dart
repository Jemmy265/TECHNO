import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:think/Core/Models/comment_model.dart';
import 'package:think/Core/Models/post_model.dart';

class FirebaseManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': userName,
          'email': email,
        });
      }

      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> updateUserName(String uid, String newName) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': newName,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> uploadData(String uid, File file, String name) async {
    var refStorage = storage.ref(uid);
    try {
      await refStorage.putFile(file);
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'imagePath': await refStorage.getDownloadURL(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> uploadName(String uid, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> getImage(String uid) async {
    var refStorage = storage.ref(uid);
    String path;
    try {
      path = await refStorage.getDownloadURL();
      return path;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> addPost(Post post) async {
    try {
      await _firestore.collection('posts').add(post.toFirestore());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('posts').get();

      List<Post> posts =
          snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();

      return posts;
    } catch (e) {
      debugPrint('Failed to fetch posts: $e');
      return [];
    }
  }

  Future<void> addComment(MyComment comment, String postId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(comment.toFirestore());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<MyComment>> getComments(String postId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      List<MyComment> comments =
          snapshot.docs.map((doc) => MyComment.fromFirestore(doc)).toList();

      return comments;
    } catch (e) {
      debugPrint('Failed to fetch comments: $e');
      return [];
    }
  }

  Future<void> likePost({
    required String postId,
    required String userId,
    required String userName,
    required String userPhoto,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).set(
        {
          'likes.$userId': userId,
          'likes.$userName': userName,
          'likes.$userPhoto': userPhoto,
          'likes_count': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

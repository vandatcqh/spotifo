// data/datasources/user_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  UserRemoteDataSource({required this.firestore, required this.firebaseAuth});
  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromDocument(doc);
        } else {
          throw Exception("User document does not exist");
        }
      }
      return null;
    } catch (e) {
      throw Exception("Get Current User Failed: $e");
    }
  }
  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Get User Failed: $e");
    }
  }

  Future<void> createUser(UserModel userModel) async {
    try {
      await firestore.collection('users').doc(userModel.id).set(userModel.toDocument());
    } catch (e) {
      throw Exception("Create User Failed: $e");
    }
  }

  Future<UserModel> updateUser(UserModel userModel) async {
    try {
      await firestore.collection('users').doc(userModel.id).update(userModel.toDocument());
      return userModel;
    } catch (e) {
      throw Exception("Update User Failed: $e");
    }
  }
  Future<void> updateFullName(String fullName) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).update({'fullName': fullName});
      } else {
        throw Exception("No user is currently signed in");
      }
    } catch (e) {
      throw Exception("Update FullName Failed: $e");
    }
  }
}

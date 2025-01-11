// data/datasources/user_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource({required this.firestore});

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

}

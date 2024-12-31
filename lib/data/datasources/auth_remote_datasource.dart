// data/datasources/auth_remote_datasource.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource({required this.firebaseAuth});

  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        return UserEntity(
          id: user.uid,
          username: email,
          password: password, // Lưu ý: Không nên lưu mật khẩu ở client
          fullName: fullName,
          dateOfBirth: dateOfBirth,
          gender: gender,
          avatarUrl: avatarUrl,
        );
      } else {
        throw Exception("User is null after sign up");
      }
    } catch (e) {
      throw Exception("Sign Up Failed: $e");
    }
  }

  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        return UserEntity(
          id: user.uid,
          username: email,
          password: password, // Lưu ý: Không nên lưu mật khẩu ở client
          fullName: '', // Thông tin bổ sung sẽ được lấy từ Firestore
        );
      } else {
        throw Exception("User is null after sign in");
      }
    } catch (e) {
      throw Exception("Sign In Failed: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Sign Out Failed: $e");
    }
  }

  Future<UserEntity?> getCurrentUser() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      return UserEntity(
        id: user.uid,
        username: user.email ?? '',
        password: '', // Không lưu mật khẩu
        fullName: '',
      );
    }
    return null;
  }
}

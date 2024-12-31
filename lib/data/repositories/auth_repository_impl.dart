// data/repositories/auth_repository_impl.dart

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.userRemoteDataSource,
  });

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) async {
    try {
      // Đăng ký với Firebase Auth
      UserEntity userEntity = await authRemoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        avatarUrl: avatarUrl,
      );

      // Tạo user trong Firestore
      UserModel userModel = UserModel(
        id: userEntity.id,
        username: userEntity.username,
        password: userEntity.password, // Lưu ý: Không nên lưu mật khẩu ở client
        fullName: userEntity.fullName,
        dateOfBirth: userEntity.dateOfBirth,
        gender: userEntity.gender,
        avatarUrl: userEntity.avatarUrl,
        favoriteArtists: userEntity.favoriteArtists,
        favoriteSongs: userEntity.favoriteSongs,
        favoriteAlbums: userEntity.favoriteAlbums,
        favoriteGenres: userEntity.favoriteGenres,
      );

      await userRemoteDataSource.createUser(userModel);

      return userEntity;
    } catch (e) {
      throw Exception("AuthRepositoryImpl signUp Failed: $e");
    }
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Đăng nhập với Firebase Auth
      UserEntity userEntity = await authRemoteDataSource.signIn(
        email: email,
        password: password,
      );

      // Lấy dữ liệu user từ Firestore
      UserModel userModel = await userRemoteDataSource.getUser(userEntity.id);

      return UserEntity(
        id: userModel.id,
        username: userModel.username,
        password: userModel.password, // Lưu ý: Không nên lưu mật khẩu ở client
        fullName: userModel.fullName,
        dateOfBirth: userModel.dateOfBirth,
        gender: userModel.gender,
        avatarUrl: userModel.avatarUrl,
        favoriteArtists: userModel.favoriteArtists,
        favoriteSongs: userModel.favoriteSongs,
        favoriteAlbums: userModel.favoriteAlbums,
        favoriteGenres: userModel.favoriteGenres,
      );
    } catch (e) {
      throw Exception("AuthRepositoryImpl signIn Failed: $e");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authRemoteDataSource.signOut();
    } catch (e) {
      throw Exception("AuthRepositoryImpl signOut Failed: $e");
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      UserEntity? userEntity = await authRemoteDataSource.getCurrentUser();
      if (userEntity != null) {
        // Lấy dữ liệu user từ Firestore
        UserModel userModel = await userRemoteDataSource.getUser(userEntity.id);
        return UserEntity(
          id: userModel.id,
          username: userModel.username,
          password: userModel.password, // Lưu ý: Không nên lưu mật khẩu ở client
          fullName: userModel.fullName,
          dateOfBirth: userModel.dateOfBirth,
          gender: userModel.gender,
          avatarUrl: userModel.avatarUrl,
          favoriteArtists: userModel.favoriteArtists,
          favoriteSongs: userModel.favoriteSongs,
          favoriteAlbums: userModel.favoriteAlbums,
          favoriteGenres: userModel.favoriteGenres,
        );
      }
      return null;
    } catch (e) {
      throw Exception("AuthRepositoryImpl getCurrentUser Failed: $e");
    }
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity updatedUser) async {
    try {
      UserModel userModel = UserModel(
        id: updatedUser.id,
        username: updatedUser.username,
        password: updatedUser.password,
        fullName: updatedUser.fullName,
        dateOfBirth: updatedUser.dateOfBirth,
        gender: updatedUser.gender,
        avatarUrl: updatedUser.avatarUrl,
        favoriteArtists: updatedUser.favoriteArtists,
        favoriteSongs: updatedUser.favoriteSongs,
        favoriteAlbums: updatedUser.favoriteAlbums,
        favoriteGenres: updatedUser.favoriteGenres,
      );

      await userRemoteDataSource.updateUser(userModel);

      return updatedUser;
    } catch (e) {
      throw Exception("AuthRepositoryImpl updateUserProfile Failed: $e");
    }
  }
}

// domain/repositories/user_repository.dart

import '../entities/user_entity.dart';
import '../entities/song_entity.dart';

abstract class UserRepository {
  /// Đăng ký tài khoản
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
  });

  /// Đăng nhập
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  /// Đăng xuất
  Future<void> signOut();

  /// Lấy user hiện tại (nếu đã đăng nhập)
  /// Trả về null nếu chưa đăng nhập
  Future<UserEntity?> getCurrentUser();

  /// Cập nhật thông tin user
  Future<UserEntity> updateUserProfile(UserEntity updatedUser);
  Future<void> updateFullName(String fullName);
  Future<List<SongEntity>> GetFavoriteSongs();
}

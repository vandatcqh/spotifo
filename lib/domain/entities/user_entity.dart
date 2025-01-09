// domain/entities/user_entity.dart

class UserEntity {
  final String id;                // id trên hệ thống (Firebase uid, v.v.)
  final String username;          // username/email
  final String password;          // password (nếu lưu plain text là không an toàn, cẩn thận!)
  final String fullName;          // họ tên
  final DateTime? dateOfBirth;    // ngày sinh
  final String? gender;           // giới tính
  final String? avatarUrl;        // url ảnh đại diện

  // Danh sách yêu thích
  final List<String> favoriteArtists;
  final List<String> favoriteSongs;
  final List<String> favoriteAlbums;
  final List<String> favoriteGenres;

  const UserEntity({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
    this.favoriteArtists = const [],
    this.favoriteSongs = const [],
    this.favoriteAlbums = const [],
    this.favoriteGenres = const [],
  });

// Nếu cần, có thể thêm copyWith, toJson, fromJson...
// NHƯNG nên để ở tầng data.
  String get userId => id;
}

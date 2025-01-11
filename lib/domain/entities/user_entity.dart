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

  UserEntity copyWith({
    String? id,
    String? username,
    String? password,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
    List<String>? favoriteArtists,
    List<String>? favoriteSongs,
    List<String>? favoriteAlbums,
    List<String>? favoriteGenres,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteArtists: favoriteArtists ?? this.favoriteArtists,
      favoriteSongs: favoriteSongs ?? this.favoriteSongs,
      favoriteAlbums: favoriteAlbums ?? this.favoriteAlbums,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
    );
  }

// Implement toJson and fromJson if needed
}

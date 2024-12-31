// data/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String username,
    required String password, // Lưu ý: Không nên lưu mật khẩu ở client
    required String fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? avatarUrl,
    List<String> favoriteArtists = const [],
    List<String> favoriteSongs = const [],
    List<String> favoriteAlbums = const [],
    List<String> favoriteGenres = const [],
  }) : super(
    id: id,
    username: username,
    password: password,
    fullName: fullName,
    dateOfBirth: dateOfBirth,
    gender: gender,
    avatarUrl: avatarUrl,
    favoriteArtists: favoriteArtists,
    favoriteSongs: favoriteSongs,
    favoriteAlbums: favoriteAlbums,
    favoriteGenres: favoriteGenres,
  );

  // Từ Firestore DocumentSnapshot sang UserModel
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'],
      password: data['password'], // Nếu có, nhưng khuyến nghị không lưu mật khẩu ở đây
      fullName: data['fullName'],
      dateOfBirth: data['dateOfBirth'] != null
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : null,
      gender: data['gender'],
      avatarUrl: data['avatarUrl'],
      favoriteArtists:
      List<String>.from(data['favoriteArtists'] ?? const []),
      favoriteSongs:
      List<String>.from(data['favoriteSongs'] ?? const []),
      favoriteAlbums:
      List<String>.from(data['favoriteAlbums'] ?? const []),
      favoriteGenres:
      List<String>.from(data['favoriteGenres'] ?? const []),
    );
  }

  // Từ UserModel sang JSON để lưu vào Firestore
  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'password': password, // Không nên lưu mật khẩu ở client
      'fullName': fullName,
      'dateOfBirth': dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth!)
          : null,
      'gender': gender,
      'avatarUrl': avatarUrl,
      'favoriteArtists': favoriteArtists,
      'favoriteSongs': favoriteSongs,
      'favoriteAlbums': favoriteAlbums,
      'favoriteGenres': favoriteGenres,
    };
  }
}

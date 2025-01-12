// data/repositories/user_repository_impl.dart

import 'package:spotifo/domain/entities/song_entity.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';
import '../models/song_model.dart';
import '../models/artist_model.dart';
import '../../domain/entities/artist_entity.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({
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
      UserEntity? userEntity = await userRemoteDataSource.getCurrentUser();
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
  @override
  Future<void> updateFullName(String fullName) async {
    try {
      await userRemoteDataSource.updateFullName(fullName);
    } catch (e) {
      throw Exception("UserRepositoryImpl updateFullName Failed: $e");
    }
  }
  @override
  Future<List<SongEntity>> GetFavoriteSongs() async {
    try {
      // Gọi hàm lấy danh sách bài hát yêu thích dưới dạng SongModel
      List<SongModel> favoriteSongModels = await userRemoteDataSource.getFavoriteSongs();
      print("dududu $favoriteSongModels.length");
      // Chuyển đổi từ SongModel sang SongEntity
      return favoriteSongModels.map((songModel) {
        return SongEntity(
          id: songModel.id,
          songName: songModel.songName,
          songImageUrl: songModel.songImageUrl,
          artistId: songModel.artistId,
          albumId: songModel.albumId,
          genre: songModel.genre,
          releaseDate: songModel.releaseDate,
          lyric: songModel.lyric,
          audioUrl: songModel.audioUrl,
        );
      }).toList();
    } catch (e) {
      throw Exception("UserRepositoryImpl GetFavoriteSongs Failed: $e");
    }
  }
  @override
  Future<void> addFavoriteSong(String songId) async {
    try {
      await userRemoteDataSource.addFavoriteSong(songId);
    } catch (e) {
      throw Exception("UserRepositoryImpl addFavoriteSong Failed: $e");
    }
  }

  @override
  Future<void> removeFavoriteSong(String songId) async {
    try {
      await userRemoteDataSource.removeFavoriteSong(songId);
    } catch (e) {
      throw Exception("UserRepositoryImpl removeFavoriteSong Failed: $e");
    }
  }

  @override
  Future<List<ArtistEntity>> GetFavoriteArtists() async {
    try {
      // Gọi hàm lấy danh sách nghệ sĩ yêu thích dưới dạng ArtistModel
      List<ArtistModel> favoriteArtistModels = await userRemoteDataSource.getFavoriteArtists();

      // Chuyển đổi từ ArtistModel sang ArtistEntity
      return favoriteArtistModels.map((artistModel) {
        return ArtistEntity(
          id: artistModel.id,
          artistName: artistModel.artistName,
          artistImageUrl: artistModel.artistImageUrl,
          followers: artistModel.followers,
          description: artistModel.description,
        );
      }).toList();
    } catch (e) {
      throw Exception("UserRepositoryImpl GetFavoriteArtists Failed: $e");
    }
  }

  @override
  Future<void> addFavoriteArtist(String artistId) async {
    try {
      await userRemoteDataSource.addFavoriteArtist(artistId);
    } catch (e) {
      throw Exception("UserRepositoryImpl addFavoriteArtist Failed: $e");
    }
  }

  @override
  Future<void> removeFavoriteArtist(String artistId) async {
    try {
      await userRemoteDataSource.removeFavoriteArtist(artistId);
    } catch (e) {
      throw Exception("UserRepositoryImpl removeFavoriteArtist Failed: $e");
    }
  }
}

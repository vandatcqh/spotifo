// data/datasources/song_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song_model.dart';

class SongRemoteDataSource {
  final FirebaseFirestore firestore;

  SongRemoteDataSource({required this.firestore});

  /// Lấy thông tin Song theo ID
  Future<SongModel> getSong(String songId) async {
    try {
      DocumentSnapshot doc = await firestore.collection('Songs').doc(songId).get();
      if (doc.exists) {
        return SongModel.fromDocument(doc);
      } else {
        throw Exception("Song not found");
      }
    } catch (e) {
      throw Exception("Get Song Failed: $e");
    }
  }

  /// Tạo mới một Song
  Future<void> createSong(SongModel songModel) async {
    try {
      await firestore.collection('Songs').doc(songModel.id).set(songModel.toDocument());
    } catch (e) {
      throw Exception("Create Song Failed: $e");
    }
  }

  /// Cập nhật thông tin một Song
  Future<SongModel> updateSong(SongModel songModel) async {
    try {
      await firestore.collection('Songs').doc(songModel.id).update(songModel.toDocument());
      return songModel;
    } catch (e) {
      throw Exception("Update Song Failed: $e");
    }
  }

  /// Xóa một Song theo ID
  Future<void> deleteSong(String songId) async {
    try {
      await firestore.collection('Songs').doc(songId).delete();
    } catch (e) {
      throw Exception("Delete Song Failed: $e");
    }
  }

  /// Lấy tất cả các Song theo Album
  Future<List<SongModel>> getSongsByAlbum(String albumId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Songs')
          .where('albumId', isEqualTo: albumId)
          .get();
      return querySnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get Songs By Album Failed: $e");
    }
  }

  /// Lấy tất cả các Song theo Artist
  Future<List<SongModel>> getSongsByArtist(String artistId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Songs')
          .where('artistId', isEqualTo: artistId)
          .get();
      return querySnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get Songs By Artist Failed: $e");
    }
  }

  /// Lấy tất cả các Song theo Genre
  Future<List<SongModel>> getSongsByGenre(String genre) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('songs')
          .where('genre', isEqualTo: genre)
          .get();
      return querySnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get Songs By Genre Failed: $e");
    }
  }

  /// Lấy tất cả các Song
  Future<List<SongModel>> getAllSongs() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('songs').get();
      return querySnapshot.docs.map((doc) => SongModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get All Songs Failed: $e");
    }
  }

  /// Lấy danh sách bài hát theo ID nghệ sĩ từ collection 'Songs' trong Firestore.
  Future<List<SongModel>> getSongsByArtistId(String artistId) async {
    try {
      print("duma: $artistId");
      final querySnapshot = await firestore
          .collection('Songs')
          .where('artistId', isEqualTo: artistId)
          .get();
      final songs = querySnapshot.docs
          .map((doc) => SongModel.fromDocument(doc))
          .toList();
      print("Số lượng bài hát cho nghệ sĩ $artistId: ${songs.length}");
      return songs;
    } catch (e) {
      throw Exception("Không thể lấy bài hát cho nghệ sĩ $artistId: $e");
    }
  }
}
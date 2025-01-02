// data/datasources/album_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/album_model.dart';

class AlbumRemoteDataSource {
  final FirebaseFirestore firestore;

  AlbumRemoteDataSource({required this.firestore});

  /// Lấy thông tin Album theo ID
  Future<AlbumModel> getAlbum(String albumId) async {
    try {
      DocumentSnapshot doc = await firestore.collection('Album').doc(albumId).get();
      if (doc.exists) {
        return AlbumModel.fromDocument(doc);
      } else {
        throw Exception("Album not found");
      }
    } catch (e) {
      throw Exception("Get Album Failed: $e");
    }
  }

  /// Tạo mới một Album
  Future<void> createAlbum(AlbumModel albumModel) async {
    try {
      await firestore.collection('Album').doc(albumModel.id).set(albumModel.toDocument());
    } catch (e) {
      throw Exception("Create Album Failed: $e");
    }
  }

  /// Cập nhật thông tin một Album
  Future<AlbumModel> updateAlbum(AlbumModel albumModel) async {
    try {
      await firestore.collection('Album').doc(albumModel.id).update(albumModel.toDocument());
      return albumModel;
    } catch (e) {
      throw Exception("Update Album Failed: $e");
    }
  }

  /// Xóa một Album theo ID
  Future<void> deleteAlbum(String albumId) async {
    try {
      await firestore.collection('Album').doc(albumId).delete();
    } catch (e) {
      throw Exception("Delete Album Failed: $e");
    }
  }

  /// Lấy tất cả các Album
  Future<List<AlbumModel>> getAllAlbums() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('Album').get();
      return querySnapshot.docs.map((doc) => AlbumModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get All Albums Failed: $e");
    }
  }
}

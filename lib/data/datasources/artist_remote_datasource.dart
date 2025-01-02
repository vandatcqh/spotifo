// data/datasources/artist_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artist_model.dart';

class ArtistRemoteDataSource {
  final FirebaseFirestore firestore;

  ArtistRemoteDataSource({required this.firestore});

  /// Lấy thông tin Artist theo ID
  Future<ArtistModel> getArtist(String artistId) async {
    try {
      DocumentSnapshot doc = await firestore.collection('Artists').doc(artistId).get();
      if (doc.exists) {
        return ArtistModel.fromDocument(doc);
      } else {
        throw Exception("Artist not found");
      }
    } catch (e) {
      throw Exception("Get Artist Failed: $e");
    }
  }

  /// Tạo mới một Artist
  Future<void> createArtist(ArtistModel artistModel) async {
    try {
      await firestore.collection('Artists').doc(artistModel.id).set(artistModel.toDocument());
    } catch (e) {
      throw Exception("Create Artist Failed: $e");
    }
  }

  /// Cập nhật thông tin một Artist
  Future<ArtistModel> updateArtist(ArtistModel artistModel) async {
    try {
      await firestore.collection('Artists').doc(artistModel.id).update(artistModel.toDocument());
      return artistModel;
    } catch (e) {
      throw Exception("Update Artist Failed: $e");
    }
  }

  /// Xóa một Artist theo ID
  Future<void> deleteArtist(String artistId) async {
    try {
      await firestore.collection('Artists').doc(artistId).delete();
    } catch (e) {
      throw Exception("Delete Artist Failed: $e");
    }
  }

  /// Lấy tất cả các Artist
  Future<List<ArtistModel>> getAllArtists() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('Artists').get();
      return querySnapshot.docs.map((doc) => ArtistModel.fromDocument(doc)).toList();
    } catch (e) {
      throw Exception("Get All Artists Failed: $e");
    }
  }
}

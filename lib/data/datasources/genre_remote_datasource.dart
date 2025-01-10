// data/datasources/genre_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/genre_model.dart';

class GenreRemoteDataSource {
  final FirebaseFirestore firestore;

  GenreRemoteDataSource({required this.firestore});

  /// Fetch all genres from the 'genres' collection in Firestore.
  Future<List<GenreModel>> getAllGenres() async {
    try {
      final querySnapshot = await firestore.collection('genres').get();
      final genres = querySnapshot.docs
          .map((doc) => GenreModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return genres;
    } catch (e) {
      throw Exception("Get All Genres Failed: $e");
    }
  }


  /// Add or update a genre in the 'genres' collection.
  Future<void> addOrUpdateGenre(GenreModel genreModel) async {
    try {
      await firestore.collection('genres').doc(genreModel.id).set(genreModel.toJson());
    } catch (e) {
      throw Exception("Add/Update Genre Failed: $e");
    }
  }

  /// Delete a genre from the 'genres' collection by its ID.
  Future<void> deleteGenre(String genreId) async {
    try {
      await firestore.collection('genres').doc(genreId).delete();
    } catch (e) {
      throw Exception("Delete Genre Failed: $e");
    }
  }
}

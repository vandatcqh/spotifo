import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artist_model.dart';

class ArtistRemoteDataSource {
  final FirebaseFirestore firestore;

  ArtistRemoteDataSource({required this.firestore});

  /// Fetch all artists from the 'artists' collection in Firestore.
  Future<List<ArtistModel>> getAllArtists() async {
    try {
      final querySnapshot = await firestore.collection('Artists').get();
      final artists = querySnapshot.docs
          .map((doc) => ArtistModel.fromDocument(doc))
          .toList();
      return artists;
    } catch (e) {
      throw Exception("Failed to fetch artists: $e");
    }
  }

  /// Add or update an artist in the 'artists' collection.
  Future<void> addOrUpdateArtist(ArtistModel artistModel) async {
    try {
      await firestore.collection('Artists').doc(artistModel.id).set(artistModel.toDocument());
    } catch (e) {
      throw Exception("Failed to add/update artist: $e");
    }
  }

  /// Delete an artist from the 'artists' collection by its ID.
  Future<void> deleteArtist(String artistId) async {
    try {
      await firestore.collection('Artists').doc(artistId).delete();
    } catch (e) {
      throw Exception("Failed to delete artist: $e");
    }
  }
}

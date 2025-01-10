import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artist_model.dart';

class ArtistRemoteDataSource {
  final FirebaseFirestore firestore;

  ArtistRemoteDataSource({required this.firestore});

    try {
    } catch (e) {
    }
  }

    try {
      await firestore.collection('Artists').doc(artistModel.id).set(artistModel.toDocument());
    } catch (e) {
    }
  }

  Future<void> deleteArtist(String artistId) async {
    try {
      await firestore.collection('Artists').doc(artistId).delete();
    } catch (e) {
    }
  }
}

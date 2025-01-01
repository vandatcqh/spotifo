// data/models/artist_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/artist_entity.dart';

class ArtistModel extends ArtistEntity {
  const ArtistModel({
    required String id,
    required String artistName,
    String? artistImageUrl,
    int followers = 0,
    String? description,
  }) : super(
    id: id,
    artistName: artistName,
    artistImageUrl: artistImageUrl,
    followers: followers,
    description: description,
  );

  // Từ Firestore DocumentSnapshot sang ArtistModel
  factory ArtistModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArtistModel(
      id: doc.id,
      artistName: data['artistName'],
      artistImageUrl: data['artistImageUrl'],
      followers: data['followers'] ?? 0,
      description: data['description'],
    );
  }

  // Từ ArtistModel sang JSON để lưu vào Firestore
  Map<String, dynamic> toDocument() {
    return {
      'artistName': artistName,
      'artistImageUrl': artistImageUrl,
      'followers': followers,
      'description': description,
    };
  }
}

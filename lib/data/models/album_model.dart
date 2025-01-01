// data/models/album_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/album_entity.dart';

class AlbumModel extends AlbumEntity {
  const AlbumModel({
    required String id,
    required String albumName,
    String? albumImageUrl,
    String? description,
    DateTime? releaseDate,
    required String byArtistId,
  }) : super(
    id: id,
    albumName: albumName,
    albumImageUrl: albumImageUrl,
    description: description,
    releaseDate: releaseDate,
    byArtistId: byArtistId,
  );

  // Từ Firestore DocumentSnapshot sang AlbumModel
  factory AlbumModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlbumModel(
      id: doc.id,
      albumName: data['albumName'],
      albumImageUrl: data['albumImageUrl'],
      description: data['description'],
      releaseDate: data['releaseDate'] != null
          ? (data['releaseDate'] as Timestamp).toDate()
          : null,
      byArtistId: data['byArtistId'],
    );
  }

  // Từ AlbumModel sang JSON để lưu vào Firestore
  Map<String, dynamic> toDocument() {
    return {
      'albumName': albumName,
      'albumImageUrl': albumImageUrl,
      'description': description,
      'releaseDate':
      releaseDate != null ? Timestamp.fromDate(releaseDate!) : null,
      'byArtistId': byArtistId,
    };
  }
}

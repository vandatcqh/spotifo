// data/models/playlist_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/playlist_entity.dart';

class PlaylistModel extends PlaylistEntity {
  const PlaylistModel({
    required String id,
    required String byUserId,
    required String playlistName,
    List<String> songIds = const [],
  }) : super(
    id: id,
    byUserId: byUserId,
    playlistName: playlistName,
    songIds: songIds,
  );

  // Từ Firestore DocumentSnapshot sang PlaylistModel
  factory PlaylistModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlaylistModel(
      id: doc.id,
      byUserId: data['byUserId'],
      playlistName: data['playlistName'],
      songIds: List<String>.from(data['songIds'] ?? const []),
    );
  }

  // Từ PlaylistModel sang JSON để lưu vào Firestore
  Map<String, dynamic> toDocument() {
    return {
      'byUserId': byUserId,
      'playlistName': playlistName,
      'songIds': songIds,
    };
  }
}

// data/models/song_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/song_entity.dart';

class SongModel extends SongEntity {
  final int playCount; // Thêm trường playCount

  const SongModel({
    required super.id,
    required super.songName,
    super.songImageUrl,
    required super.artistId,
    required super.albumId,
    required super.genre,
    super.releaseDate,
    super.lyric,
    required super.audioUrl,
    this.playCount = 0,
  });

  /// Từ Firestore DocumentSnapshot sang SongModel
  factory SongModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SongModel(
      id: doc.id,
      songName: data['songName'],
      songImageUrl: data['songImageUrl'],
      artistId: data['artistId'],
      albumId: data['albumId'],
      genre: data['genre'],
      releaseDate: data['releaseDate'] != null
          ? (data['releaseDate'] as Timestamp).toDate()
          : null,
      lyric: data['lyric'],
      audioUrl: data['audioUrl'],
      playCount: data['playCount'] ?? 0, // Lấy playCount hoặc mặc định là 0
    );
  }

  /// Từ SongModel sang JSON để lưu vào Firestore
  Map<String, dynamic> toDocument() {
    return {
      'songName': songName,
      'songImageUrl': songImageUrl,
      'artistId': artistId,
      'albumId': albumId,
      'genre': genre,
      'releaseDate':
      releaseDate != null ? Timestamp.fromDate(releaseDate!) : null,
      'lyric': lyric,
      'audioUrl': audioUrl,
      'playCount': playCount, // Bao gồm playCount trong JSON
    };
  }
}
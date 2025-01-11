// data/models/song_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/song_entity.dart';

class SongModel extends SongEntity {
  final int playCount; // Thêm trường playCount

  const SongModel({
    required String id,
    required String songName,
    String? songImageUrl,
    required String artistId,
    required String albumId,
    required String genre,
    DateTime? releaseDate,
    String? lyric,
    required String audioUrl,
    this.playCount = 0,
  }) : super(
    id: id,
    songName: songName,
    songImageUrl: songImageUrl,
    artistId: artistId,
    albumId: albumId,
    genre: genre,
    releaseDate: releaseDate,
    lyric: lyric,
    audioUrl: audioUrl,
  );

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
  @override
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
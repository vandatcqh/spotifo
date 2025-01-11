// domain/repositories/music_repository.dart


import '../entities/song_entity.dart';

abstract class MusicRepository {
  /// Lấy các bài hát hot
  Future<List<SongEntity>> getHotSongs();
}
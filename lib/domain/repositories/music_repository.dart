// domain/repositories/music_repository.dart

import '../entities/album_entity.dart';
import '../entities/artist_entity.dart';
import '../entities/playlist_entity.dart';
import '../entities/song_entity.dart';

abstract class MusicRepository {
  /// Lấy các bài hát hot
  Future<List<SongEntity>> getHotSongs();
}
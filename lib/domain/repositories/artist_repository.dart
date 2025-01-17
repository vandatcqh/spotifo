// domain/repositories/artist_repository.dart

import '../entities/artist_entity.dart';
import '../entities/song_entity.dart';

abstract class ArtistRepository {
  /// Lấy tất cả nghệ sĩ
  Future<List<ArtistEntity>> getAllArtists();

  /// Tăng số người theo dõi của nghệ sĩ
  Future<void> increaseFollower(String artistId);

  /// Giảm số người theo dõi của nghệ sĩ
  Future<void> decreaseFollower(String artistId);

  /// Lấy danh sách bài hát theo ID nghệ sĩ
  Future<List<SongEntity>> getSongsByArtistId(String artistId);
}

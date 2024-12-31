// domain/repositories/music_repository.dart

import '../entities/album_entity.dart';
import '../entities/artist_entity.dart';
import '../entities/playlist_entity.dart';
import '../entities/song_entity.dart';

abstract class MusicRepository {
  /// Lấy các bài hát hot
  Future<List<SongEntity>> getHotSongs();

  /// Lấy các album hot
  Future<List<AlbumEntity>> getHotAlbums();

  /// Lấy các nghệ sĩ hot
  Future<List<ArtistEntity>> getHotArtists();

  /// Lấy chi tiết một bài hát
  Future<SongEntity> getSongById(String songId);

  /// Lấy chi tiết một album
  Future<AlbumEntity> getAlbumById(String albumId);

  /// Lấy chi tiết một nghệ sĩ
  Future<ArtistEntity> getArtistById(String artistId);

  /// Tìm kiếm nghệ sĩ theo tên
  Future<List<ArtistEntity>> searchArtistsByName(String keyword);

  /// Tìm kiếm bài hát / album / ...
  /// (có thể thêm hàm searchSongByName, searchAlbumByName, searchAll, tuỳ ý)
  Future<List<SongEntity>> searchSongsByName(String keyword);

  /// Thêm bài hát vào danh sách yêu thích
  Future<void> likeSong(String userId, String songId);

  /// Bỏ thích bài hát
  Future<void> unlikeSong(String userId, String songId);

  /// Tạo Playlist
  Future<PlaylistEntity> createPlaylist({
    required String userId,
    required String playlistName,
  });

  /// Lấy danh sách Playlist của user
  Future<List<PlaylistEntity>> getUserPlaylists(String userId);

  /// Cập nhật playlist (thêm / bớt bài hát)
  Future<PlaylistEntity> updatePlaylist(PlaylistEntity playlist);

  /// Xoá playlist
  Future<void> deletePlaylist(String playlistId);

  /// Lấy lời bài hát
  /// (nếu lyric được tách rời, tuỳ mô hình data)
  Future<String?> getSongLyric(String songId);

/// ...
}

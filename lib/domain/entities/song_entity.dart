// domain/entities/song_entity.dart

class SongEntity {
  final String id;               // id của bài hát
  final String songName;
  final String? songImageUrl;
  final String artistId;         // ID của nghệ sĩ
  final String albumId;          // ID của album
  final String genre;            // thể loại
  final DateTime? releaseDate;   // ngày phát hành
  final String? lyric;           // lời bài hát
  final String audioUrl;         // đường dẫn audio

  const SongEntity({
    required this.id,
    required this.songName,
    this.songImageUrl,
    required this.artistId,
    required this.albumId,
    required this.genre,
    this.releaseDate,
    this.lyric,
    required this.audioUrl,
  });
}

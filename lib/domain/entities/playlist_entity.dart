// domain/entities/playlist_entity.dart

class PlaylistEntity {
  final String id;                 // id của playlist
  final String byUserId;           // ai tạo playlist
  final String playlistName;
  final List<String> songIds;      // danh sách id bài hát

  const PlaylistEntity({
    required this.id,
    required this.byUserId,
    required this.playlistName,
    this.songIds = const [],
  });
}

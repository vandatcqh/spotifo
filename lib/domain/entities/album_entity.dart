// domain/entities/album_entity.dart

class AlbumEntity {
  final String id;              // id của album
  final String albumName;
  final String? albumImageUrl;
  final String? description;
  final DateTime? releaseDate;   // thời gian phát hành
  final String byArtistId;       // ID của nghệ sĩ

  const AlbumEntity({
    required this.id,
    required this.albumName,
    this.albumImageUrl,
    this.description,
    this.releaseDate,
    required this.byArtistId,
  });
}

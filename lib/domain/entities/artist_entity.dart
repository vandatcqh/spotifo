// domain/entities/artist_entity.dart

class ArtistEntity {
  final String id;               // id của nghệ sĩ
  final String artistName;       // tên nghệ sĩ
  final String? artistImageUrl;  // ảnh
  final int followers;           // số người theo dõi
  final String? description;     // mô tả

  const ArtistEntity({
    required this.id,
    required this.artistName,
    this.artistImageUrl,
    this.followers = 0,
    this.description,
  });
}

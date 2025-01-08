abstract class ArtistState {}

class ArtistInitial extends ArtistState {}

class ArtistLoading extends ArtistState {}

/// Nghệ sĩ hot
class ArtistHotLoaded extends ArtistState {
  final List<dynamic> artists; // Thay = List<ArtistEntity>

  ArtistHotLoaded(this.artists);
}

/// Kết quả tìm kiếm nghệ sĩ
class ArtistSearchResultsLoaded extends ArtistState {
  final List<dynamic> artists; // Thay = List<ArtistEntity>

  ArtistSearchResultsLoaded(this.artists);
}

class ArtistError extends ArtistState {
  final String message;
  ArtistError(this.message);
}

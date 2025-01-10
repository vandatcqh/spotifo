abstract class SongState {}

class SongInitial extends SongState {}

class SongLoading extends SongState {}

/// Bài hát hot
class SongHotLoaded extends SongState {
  final List<dynamic> songs; // Thay = List<SongEntity>

  SongHotLoaded(this.songs);
}

/// Kết quả search bài hát
class SongSearchResultsLoaded extends SongState {
  final List<dynamic> songs; // Thay = List<SongEntity>

  SongSearchResultsLoaded(this.songs);
}

/// Đã like bài hát
class SongLiked extends SongState {}

/// Đã unlike bài hát
class SongUnliked extends SongState {}

class SongError extends SongState {
  final String message;
  SongError(this.message);
}

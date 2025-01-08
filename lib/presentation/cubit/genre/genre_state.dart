import '../../../domain/entities/genre_entity.dart';

/// Trạng thái cơ bản của GenreCubit
abstract class GenreState {
  final List<String> selectedGenres;

  const GenreState(this.selectedGenres);
}

/// Trạng thái ban đầu
class GenreInitial extends GenreState {
  GenreInitial(List<String> selectedGenres) : super(selectedGenres);
}

/// Trạng thái đang tải danh sách thể loại
class GenreLoading extends GenreState {
  GenreLoading() : super([]);
}

/// Trạng thái tải danh sách thể loại thành công
class GenreLoaded extends GenreState {
  final List<String> genres; // Danh sách thể loại đã tải từ usecase

  GenreLoaded(this.genres) : super([]);
}

/// Trạng thái gặp lỗi khi tải danh sách thể loại
class GenreError extends GenreState {
  final String message;

  GenreError(this.message) : super([]);
}

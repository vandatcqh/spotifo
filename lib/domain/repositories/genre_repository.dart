// domain/repositories/genre_repository.dart
import '../entities/genre_entity.dart';

abstract class GenreRepository {
  // Lấy danh sách thể loại từ Firebase
  Future<List<GenreEntity>> GetAllGenres();

  // Cập nhật danh sách thể loại yêu thích của người dùng
  Future<void> updateFavoriteGenres(String userId, List<String> genreIds);
}

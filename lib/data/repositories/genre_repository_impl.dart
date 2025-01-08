import '../../domain/entities/genre_entity.dart';
import '../../domain/repositories/genre_repository.dart';
import '../datasources/genre_remote_datasource.dart';
import '../models/genre_model.dart';

class GenreRepositoryImpl implements GenreRepository {
  final GenreRemoteDataSource remoteDataSource;

  GenreRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<GenreEntity>> GetAllGenres() async {
    try {
      // Sử dụng remoteDataSource để lấy danh sách genres
      final genreModels = await remoteDataSource.getAllGenres();

      // Chuyển đổi từ GenreModel sang GenreEntity nếu cần thiết
      return genreModels.map((model) => GenreEntity(
        id: model.id,
        name: model.name,
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }

  @override
  Future<void> updateFavoriteGenres(String userId, List<String> genreIds) async {
    try {
      // Sử dụng Firestore thông qua GenreRemoteDataSource nếu cần thêm logic tại đây
      await remoteDataSource.firestore
          .collection('users')
          .doc(userId)
          .update({'favoriteGenres': genreIds});
    } catch (e) {
      throw Exception('Failed to update favorite genres: $e');
    }
  }
}

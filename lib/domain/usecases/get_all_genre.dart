// domain/usecases/get_all_genre.dart
import '../entities/genre_entity.dart';
import '../repositories/genre_repository.dart';

class GetAllGenresUseCase {
  final GenreRepository repository;

  GetAllGenresUseCase(this.repository);

  Future<List<GenreEntity>> call() async {
    return await repository.GetAllGenres();
  }
}

// domain/usecases/get_all_artists.dart

import '../entities/artist_entity.dart';
import '../repositories/artist_repository.dart';

class GetAllArtistsUseCase {
  final ArtistRepository repository;

  GetAllArtistsUseCase(this.repository);

  Future<List<ArtistEntity>> call() async {
    return await repository.getAllArtists();
  }
}

// domain/usecases/music/search_artists_by_name.dart

import '../entities/artist_entity.dart';
import '../repositories/music_repository.dart';

class SearchArtistsByNameUseCase {
  final MusicRepository musicRepository;

  SearchArtistsByNameUseCase(this.musicRepository);

  Future<List<ArtistEntity>> call(String keyword) {
    return musicRepository.searchArtistsByName(keyword);
  }
}

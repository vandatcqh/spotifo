// domain/usecases/music/get_hot_artists.dart

import '../entities/artist_entity.dart';
import '../repositories/music_repository.dart';

class GetHotArtistsUseCase {
  final MusicRepository musicRepository;

  GetHotArtistsUseCase(this.musicRepository);

  Future<List<ArtistEntity>> call() {
    return musicRepository.getHotArtists();
  }
}

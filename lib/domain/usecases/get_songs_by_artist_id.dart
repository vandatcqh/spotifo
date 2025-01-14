// domain/usecases/get_songs_by_artist_id.dart
import '../entities/song_entity.dart';
import '../repositories/artist_repository.dart';

class GetSongsByArtistIdUseCase {
  final ArtistRepository repository;

  GetSongsByArtistIdUseCase(this.repository);

  Future<List<SongEntity>> call(String artistId) async {
    return await repository.getSongsByArtistId(artistId);
  }
}

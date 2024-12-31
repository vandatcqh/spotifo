// domain/usecases/music/search_songs_by_name.dart

import '../entities/song_entity.dart';
import '../repositories/music_repository.dart';

class SearchSongsByNameUseCase {
  final MusicRepository musicRepository;

  SearchSongsByNameUseCase(this.musicRepository);

  Future<List<SongEntity>> call(String keyword) {
    return musicRepository.searchSongsByName(keyword);
  }
}

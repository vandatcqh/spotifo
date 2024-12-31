// domain/usecases/music/get_hot_songs.dart

import '../entities/song_entity.dart';
import '../repositories/music_repository.dart';

class GetHotSongsUseCase {
  final MusicRepository musicRepository;

  GetHotSongsUseCase(this.musicRepository);

  Future<List<SongEntity>> call() {
    return musicRepository.getHotSongs();
  }
}

// domain/usecases/music/unlike_song.dart

import '../repositories/music_repository.dart';

class UnlikeSongUseCase {
  final MusicRepository musicRepository;

  UnlikeSongUseCase(this.musicRepository);

  Future<void> call(String userId, String songId) {
    return musicRepository.unlikeSong(userId, songId);
  }
}

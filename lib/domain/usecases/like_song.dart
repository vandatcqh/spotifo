// domain/usecases/music/like_song.dart

import '../repositories/music_repository.dart';

class LikeSongUseCase {
  final MusicRepository musicRepository;

  LikeSongUseCase(this.musicRepository);

  Future<void> call(String userId, String songId) {
    return musicRepository.likeSong(userId, songId);
  }
}

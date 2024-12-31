// domain/usecases/music/delete_playlist.dart

import '../repositories/music_repository.dart';

class DeletePlaylistUseCase {
  final MusicRepository musicRepository;

  DeletePlaylistUseCase(this.musicRepository);

  Future<void> call(String playlistId) {
    return musicRepository.deletePlaylist(playlistId);
  }
}

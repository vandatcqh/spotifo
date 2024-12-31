// domain/usecases/music/create_playlist.dart

import '../entities/playlist_entity.dart';
import '../repositories/music_repository.dart';

class CreatePlaylistUseCase {
  final MusicRepository musicRepository;

  CreatePlaylistUseCase(this.musicRepository);

  Future<PlaylistEntity> call({
    required String userId,
    required String playlistName,
  }) {
    return musicRepository.createPlaylist(
      userId: userId,
      playlistName: playlistName,
    );
  }
}

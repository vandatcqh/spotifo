// domain/usecases/music/update_playlist.dart

import '../entities/playlist_entity.dart';
import '../repositories/music_repository.dart';

class UpdatePlaylistUseCase {
  final MusicRepository musicRepository;

  UpdatePlaylistUseCase(this.musicRepository);

  Future<PlaylistEntity> call(PlaylistEntity playlist) {
    return musicRepository.updatePlaylist(playlist);
  }
}

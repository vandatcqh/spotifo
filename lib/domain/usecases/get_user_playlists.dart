// domain/usecases/music/get_user_playlists.dart

import '../entities/playlist_entity.dart';
import '../repositories/music_repository.dart';

class GetUserPlaylistsUseCase {
  final MusicRepository musicRepository;

  GetUserPlaylistsUseCase(this.musicRepository);

  Future<List<PlaylistEntity>> call(String userId) {
    return musicRepository.getUserPlaylists(userId);
  }
}

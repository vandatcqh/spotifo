// domain/usecases/music/get_hot_albums.dart

import '../entities/album_entity.dart';
import '../repositories/music_repository.dart';

class GetHotAlbumsUseCase {
  final MusicRepository musicRepository;

  GetHotAlbumsUseCase(this.musicRepository);

  Future<List<AlbumEntity>> call() {
    return musicRepository.getHotAlbums();
  }
}

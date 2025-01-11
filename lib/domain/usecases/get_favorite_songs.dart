// domain/usecases/music/get_favorite_songs.dart

import '../entities/song_entity.dart';
import '../repositories/user_repository.dart';

class GetFavoriteSongsUseCase {
  final UserRepository userRepository;

  GetFavoriteSongsUseCase(this.userRepository);

  Future<List<SongEntity>> call() {
    return userRepository.GetFavoriteSongs();
  }
}
// domain/usecases/music/get_favorite_songs.dart

import '../entities/song_entity.dart';
import '../repositories/user_repository.dart';

class GetFavoriteSongsUseCase {
  final UserRepository userRepository;

  GetFavoriteSongsUseCase(this.userRepository);

  /// Lấy danh sách bài hát yêu thích
  Future<List<SongEntity>> call() {
    return userRepository.GetFavoriteSongs();
  }

  /// Thêm bài hát vào danh sách yêu thích
  Future<void> addFavoriteSong(String songId) {
    return userRepository.addFavoriteSong(songId);
  }

  /// Xóa bài hát khỏi danh sách yêu thích
  Future<void> removeFavoriteSong(String songId) {
    return userRepository.removeFavoriteSong(songId);
  }
}

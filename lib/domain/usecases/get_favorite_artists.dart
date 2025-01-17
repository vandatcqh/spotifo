// domain/usecases/get_favorite_artists.dart

import '../entities/artist_entity.dart';
import '../repositories/user_repository.dart';
import '../repositories/artist_repository.dart';

class GetFavoriteArtistsUseCase {
  final UserRepository userRepository;

  final ArtistRepository artistRepository;

  GetFavoriteArtistsUseCase(this.userRepository, this.artistRepository);

  /// Lấy danh sách nghệ sĩ yêu thích
  Future<List<ArtistEntity>> call() {
    return userRepository.GetFavoriteArtists();
  }

  /// Thêm nghệ sĩ vào danh sách yêu thích
  Future<void> addFavoriteArtist(String artistId) async {
    await userRepository.addFavoriteArtist(artistId);
    await artistRepository.increaseFollower(artistId);
  }

  /// Xóa nghệ sĩ khỏi danh sách yêu thích
  Future<void> removeFavoriteArtist(String artistId) async {
    await userRepository.removeFavoriteArtist(artistId);
    await artistRepository.decreaseFollower(artistId);
  }
}

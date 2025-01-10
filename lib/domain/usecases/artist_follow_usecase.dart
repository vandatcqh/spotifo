// domain/usecases/artist_follow_usecase.dart

import '../repositories/artist_repository.dart';

class ArtistFollowUseCase {
  final ArtistRepository artistRepository;

  ArtistFollowUseCase(this.artistRepository);

  /// Tăng số người theo dõi của nghệ sĩ
  Future<void> increaseFollower(String artistId) async {
    await artistRepository.increaseFollower(artistId);
  }

  /// Giảm số người theo dõi của nghệ sĩ
  Future<void> decreaseFollower(String artistId) async {
    await artistRepository.decreaseFollower(artistId);
  }
}

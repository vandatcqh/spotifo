import '../repositories/player_repository.dart';

class SetSongSpeedUseCase {
  final PlayerRepository playerRepository;

  SetSongSpeedUseCase(this.playerRepository);

  Future<void> call(double speed) async {
    await playerRepository.setPlaybackSpeed(speed);
  }
}

import '../repositories/player_repository.dart';

class PlaySongUseCase {
  final PlayerRepository playerRepository;

  PlaySongUseCase(this.playerRepository);

  Stream<Duration> get positionStream => playerRepository.getPositionStream();
  Stream<Duration?> get durationStream => playerRepository.getDurationStream();

  Future<void> call(String audioUrl) async {
    await playerRepository.play(audioUrl);
  }
}

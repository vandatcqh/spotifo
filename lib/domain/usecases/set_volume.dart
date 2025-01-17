import '../repositories/player_repository.dart';

class SetVolumeUseCase {
  final PlayerRepository repository;

  SetVolumeUseCase(this.repository);

  Future<void> call(double volume) async {
    await repository.setVolume(volume);
  }
}
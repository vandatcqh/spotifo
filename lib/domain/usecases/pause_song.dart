import '../repositories/player_repository.dart';

class PauseSongUseCase {
  final PlayerRepository repository;

  PauseSongUseCase(this.repository);

  Future<void> call() async {
    return await repository.pause();
  }
}
import '../repositories/player_repository.dart';

class ResumeSongUseCase {
  final PlayerRepository repository;

  ResumeSongUseCase(this.repository);

  Future<void> call() async {
    return await repository.resume();
  }
}
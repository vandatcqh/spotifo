import '../repositories/player_repository.dart';

class SeekSongUseCase {
  final PlayerRepository repository;

  SeekSongUseCase(this.repository);

  Future<void> call(Duration position) async {
    return await repository.seek(position);
  }
}
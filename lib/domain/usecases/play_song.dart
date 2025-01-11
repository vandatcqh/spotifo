import 'package:spotifo/domain/entities/song_entity.dart';

import '../repositories/player_repository.dart';

class PlaySongUseCase {
  final PlayerRepository repository;

  PlaySongUseCase(this.repository);

  Future<void> call(String audioUrl) async {
    return await repository.play(audioUrl);
  }
}
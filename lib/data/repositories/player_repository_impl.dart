import 'package:just_audio/just_audio.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import '../../domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final AudioPlayer _audioPlayer;

  PlayerRepositoryImpl(this._audioPlayer);

  @override
  Future<void> play(String audioUrl) async {
    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      throw Exception("Error while playing: $e");
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw Exception("Error while pausing: $e");
    }
  }

  @override
  Future<void> resume() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      throw Exception("Error while resuming: $e");
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      throw Exception("Error while seeking: $e");
    }
  }
}
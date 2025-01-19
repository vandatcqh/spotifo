import 'package:just_audio/just_audio.dart';
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

  @override
  Stream<Duration> getPositionStream() {
    try {
      return _audioPlayer.positionStream;
    } catch (e) {
      throw Exception("Error while fetching position stream: $e");
    }
  }

  @override
  Stream<Duration?> getDurationStream() {
    try {
      return _audioPlayer.durationStream;
    } catch (e) {
      throw Exception("Error while fetching duration stream: $e");
    }
  }


  @override
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      throw Exception("Error while setting volume: $e");
    }
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
    } catch (e) {
      throw Exception("Error setting playback speed: $e");
    }
  }
}

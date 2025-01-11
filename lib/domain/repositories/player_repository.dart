import 'dart:async';

abstract class PlayerRepository {
  Stream<Duration> getPositionStream();
  Stream<Duration?> getDurationStream();
  Future<void> play(String audioUrl);
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setPlaybackSpeed(double speed);
}

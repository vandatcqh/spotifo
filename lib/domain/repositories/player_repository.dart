import 'package:spotifo/domain/entities/song_entity.dart';

abstract class PlayerRepository {
  Future<void> play(String audioUrl);
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);
}
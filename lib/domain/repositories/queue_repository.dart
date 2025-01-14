import '../entities/song_entity.dart';

abstract class QueueRepository {
  Future<List<SongEntity>> getQueue();
  Future<void> addSongToQueue(SongEntity song);
  Future<void> removeSongFromQueue(SongEntity song);
  Future<void> shuffleQueue();
  Future<void> updateQueue(List<SongEntity> newQueue);
  Future<void> addSongsToQueue(List<SongEntity> songs);
}

import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/domain/repositories/queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  final List<SongEntity> _queue = [];

  @override
  Future<List<SongEntity>> getQueue() async {
    print("QueueRepositoryImpl: Fetching queue. Current queue length: ${_queue.length}");
    return Future.value(List.from(_queue));
  }

  @override
  Future<void> addSongToQueue(SongEntity song) async {
    print("QueueRepositoryImpl: Adding song to queue: ${song.songName}");
    _queue.add(song);
    print("QueueRepositoryImpl: Queue length after adding: ${_queue.length}");
    return Future.value();
  }

  @override
  Future<void> removeSongFromQueue(SongEntity song) async {
    print("QueueRepositoryImpl: Removing song from queue: ${song.songName}");
    _queue.remove(song);
    print("QueueRepositoryImpl: Queue length after removing: ${_queue.length}");
    return Future.value();
  }

  @override
  Future<void> shuffleQueue() async {
    print("QueueRepositoryImpl: Shuffling queue...");
    _queue.shuffle();
    print("QueueRepositoryImpl: Queue shuffled.");
    return Future.value();
  }

  @override
  Future<void> updateQueue(List<SongEntity> newQueue) async {
    print("QueueRepositoryImpl: Updating queue...");
    _queue.clear();
    _queue.addAll(newQueue);
    print("QueueRepositoryImpl: Queue updated. New length: ${_queue.length}");
    return Future.value();
  }

  @override
  Future<void> addSongsToQueue(List<SongEntity> songs) async {
    print("QueueRepositoryImpl: Adding ${songs.length} songs to queue...");
    _queue.addAll(songs);
    print("QueueRepositoryImpl: Queue length after adding multiple songs: ${_queue.length}");
    return Future.value();
  }
}

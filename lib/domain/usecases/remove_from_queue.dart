import '../entities/song_entity.dart';
import '../repositories/queue_repository.dart';

class RemoveFromQueue {
  final QueueRepository repository;

  RemoveFromQueue(this.repository);

  Future<void> call(SongEntity song) async {
    return repository.removeSongFromQueue(song);
  }
}

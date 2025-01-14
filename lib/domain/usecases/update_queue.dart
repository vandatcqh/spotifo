import '../entities/song_entity.dart';
import '../repositories/queue_repository.dart';

class UpdateQueue {
  final QueueRepository repository;

  UpdateQueue(this.repository);

  Future<void> call(List<SongEntity> newQueue) async {
    return repository.updateQueue(newQueue);
  }
}

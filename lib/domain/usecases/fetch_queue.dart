import '../entities/song_entity.dart';
import '../repositories/queue_repository.dart';

class FetchQueue {
  final QueueRepository repository;

  FetchQueue(this.repository);

  Future<List<SongEntity>> call() async {
    return repository.getQueue();
  }
}

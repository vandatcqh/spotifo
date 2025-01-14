import '../entities/song_entity.dart';
import '../repositories/queue_repository.dart';

class AddToQueue {
  final QueueRepository repository;

  AddToQueue(this.repository);

  Future<void> call(SongEntity song) async {
    return repository.addSongToQueue(song);
  }
}

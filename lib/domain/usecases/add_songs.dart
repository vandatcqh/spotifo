// domain/usecases/add_songs_to_queue.dart
import '../entities/song_entity.dart';
import '../repositories/queue_repository.dart';

class AddSongsToQueueUseCase {
  final QueueRepository repository;

  AddSongsToQueueUseCase(this.repository);

  Future<void> call(List<SongEntity> songs) async {
    return repository.addSongsToQueue(songs);
  }
}

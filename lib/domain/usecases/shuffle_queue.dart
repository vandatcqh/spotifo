import '../repositories/queue_repository.dart';

class ShuffleQueue {
  final QueueRepository repository;

  ShuffleQueue(this.repository);

  Future<void> call() async {
    return repository.shuffleQueue();
  }
}

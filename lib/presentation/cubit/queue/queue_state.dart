
import 'package:equatable/equatable.dart';

import '../../../domain/entities/song_entity.dart';

abstract class QueueState extends Equatable {
  const QueueState();

  @override
  List<Object?> get props => [];
}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueLoaded extends QueueState {
  final List<SongEntity> queue;
  final SongEntity? currentSong;

  const QueueLoaded({
    required this.queue,
    this.currentSong,
  });

  @override
  List<Object?> get props => [queue, currentSong];
}

class QueueError extends QueueState {
  final String error;

  const QueueError(this.error);

  @override
  List<Object?> get props => [error];
}

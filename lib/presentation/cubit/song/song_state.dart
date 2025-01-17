import 'package:equatable/equatable.dart';
import '../../../domain/entities/song_entity.dart';

abstract class SongInfoState extends Equatable {
  const SongInfoState();

  @override
  List<Object?> get props => [];
}

class SongInfoInitial extends SongInfoState {}

class SongInfoLoading extends SongInfoState {}

class SongHotSongsLoaded extends SongInfoState {
  final List<SongEntity> songs;

  const SongHotSongsLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class SongByGenreLoaded extends SongInfoState {
  final String genre;
  final List<SongEntity> songs;

  const SongByGenreLoaded(this.genre, this.songs);

  @override
  List<Object?> get props => [genre, songs];
}

class SongError extends SongInfoState {
  final String error;

  const SongError(this.error);

  @override
  List<Object?> get props => [error];
}

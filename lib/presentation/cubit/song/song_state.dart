/*
abstract class SongState {}

class SongInitial extends SongState {}

class SongLoading extends SongState {}

/// Bài hát hot
class SongHotLoaded extends SongState {
  final List<dynamic> songs; // Thay = List<SongEntity>

  SongHotLoaded(this.songs);
}

/// Kết quả search bài hát
class SongSearchResultsLoaded extends SongState {
  final List<dynamic> songs; // Thay = List<SongEntity>

  SongSearchResultsLoaded(this.songs);
}

/// Đã like bài hát
class SongLiked extends SongState {}

/// Đã unlike bài hát
class SongUnliked extends SongState {}

class SongError extends SongState {
  final String message;
  SongError(this.message);
}
*/
import 'package:equatable/equatable.dart';
import '../../../domain/entities/album_entity.dart';
import '../../../domain/entities/artist_entity.dart';
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

class SongError extends SongInfoState {
  final String error;

  const SongError(this.error);

  @override
  List<Object?> get props => [error];
}
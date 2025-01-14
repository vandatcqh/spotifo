// presentation/cubit/favoriteSongs/favorite_songs_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/song_entity.dart';

abstract class FavoriteSongsState extends Equatable {
  const FavoriteSongsState();

  @override
  List<Object?> get props => [];
}

class FavoriteSongsInitial extends FavoriteSongsState {}

class FavoriteSongsLoading extends FavoriteSongsState {}

class FavoriteSongsLoaded extends FavoriteSongsState {
  final List<SongEntity> favoriteSongs;

  const FavoriteSongsLoaded(this.favoriteSongs);

  @override
  List<Object?> get props => [favoriteSongs];
}

class FavoriteSongsError extends FavoriteSongsState {
  final String message;

  const FavoriteSongsError(this.message);

  @override
  List<Object?> get props => [message];
}
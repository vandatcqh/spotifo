import 'package:equatable/equatable.dart';

import '../../../domain/entities/song_entity.dart';

abstract class AppPlayerState extends Equatable {
  const AppPlayerState();

  @override
  List<Object?> get props => [];
}

class PlayerInitial extends AppPlayerState {}

class PlayerLoading extends AppPlayerState {}

class PlayerPlaying extends AppPlayerState {
  final SongEntity currentSong;
  final Duration position;

  const PlayerPlaying(this.currentSong, this.position);

  @override
  List<Object?> get props => [currentSong, position];
}

class PlayerPaused extends AppPlayerState {
  final SongEntity currentSong;
  final Duration position;

  const PlayerPaused(this.currentSong, this.position);

  @override
  List<Object?> get props => [currentSong, position];
}

class PlayerError extends AppPlayerState {
  final String error;

  const PlayerError(this.error);

  @override
  List<Object?> get props => [error];
}
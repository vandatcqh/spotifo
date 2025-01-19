import 'package:equatable/equatable.dart';
import '../../../domain/entities/song_entity.dart';

abstract class AppPlayerState extends Equatable {
  const AppPlayerState();

  Duration get position => Duration.zero; // Giá trị mặc định
  Duration get totalDuration => Duration.zero; // Giá trị mặc định

  @override
  List<Object?> get props => [];
}

class PlayerInitial extends AppPlayerState {}

class PlayerLoading extends AppPlayerState {}

class PlayerPlaying extends AppPlayerState {
  final SongEntity currentSong;
  @override
  final Duration position;
  @override
  final Duration totalDuration;

  const PlayerPlaying(this.currentSong, this.position, this.totalDuration);

  @override
  List<Object?> get props => [currentSong, position, totalDuration];
}

class PlayerPaused extends AppPlayerState {
  final SongEntity currentSong;
  @override
  final Duration position;
  @override
  final Duration totalDuration;

  const PlayerPaused(this.currentSong, this.position, this.totalDuration);

  @override
  List<Object?> get props => [currentSong, position, totalDuration];
}

class PlayerError extends AppPlayerState {
  final String error;

  const PlayerError(this.error);

  @override
  List<Object?> get props => [error];
}

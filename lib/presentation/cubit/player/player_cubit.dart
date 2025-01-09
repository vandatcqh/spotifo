import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/presentation/cubit/player/player_state.dart';

import '../../../domain/usecases/pause_song.dart';
import '../../../domain/usecases/play_song.dart';
import '../../../domain/usecases/resume_song.dart';
import '../../../domain/usecases/seek_song.dart';

class PlayerCubit extends Cubit<AppPlayerState> {
  final PlaySongUseCase playSongUseCase;
  final PauseSongUseCase pauseSongUseCase;
  final ResumeSongUseCase resumeSongUseCase;
  final SeekSongUseCase seekSongUseCase;

  PlayerCubit({
    required this.playSongUseCase,
    required this.pauseSongUseCase,
    required this.resumeSongUseCase,
    required this.seekSongUseCase,
  }) : super(PlayerInitial());

  Future<void> playSong(SongEntity song) async {
    try {
      emit(PlayerLoading());
      await playSongUseCase.call(song.audioUrl);
      emit(PlayerPlaying(song, const Duration()));
    } catch (e) {
      emit(PlayerError("Cannot play song: $e"));
    }
  }

  Future<void> pauseSong() async {
    try {
      if (state is PlayerPlaying) {
        final currentState = state as PlayerPlaying;
        await pauseSongUseCase.call();
        emit(PlayerPaused(currentState.currentSong, currentState.position));
      }
    } catch (e) {
      emit(PlayerError("Cannot pause song: $e"));
    }
  }

  Future<void> resumeSong() async {
    try {
      if (state is PlayerPaused) {
        final currentState = state as PlayerPaused;
        await resumeSongUseCase.call();
        emit(PlayerPlaying(currentState.currentSong, currentState.position));
      }
    } catch (e) {
      emit(PlayerError("Cannot resume song: $e"));
    }
  }

  Future<void> seekSong(Duration position) async {
    try {
      await seekSongUseCase.call(position);
      if (state is PlayerPlaying) {
        final currentState = state as PlayerPlaying;
        emit(PlayerPlaying(currentState.currentSong, position));
      } else if (state is PlayerPaused) {
        final currentState = state as PlayerPaused;
        emit(PlayerPaused(currentState.currentSong, position));
      }
    } catch (e) {
      emit(PlayerError("Cannot seek song: $e"));
    }
  }
}
// lib/presentation/cubit/player/player_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
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

  SongEntity? _currentSong;

  Future<void> togglePlayPause(SongEntity song) async {
    try {
      print('Toggle Play/Pause pressed. Current state: $state');

      if (state is PlayerInitial || _currentSong?.id != song.id) {
        // Phát bài hát mới
        _currentSong = song;
        emit(PlayerPlaying(song, const Duration()));
        await playSongUseCase.call(song.audioUrl);
        print('Emitted PlayerPlaying for song: ${song.songName}');
        return;
      }

      if (state is PlayerPlaying) {
        // Tạm dừng bài hát
        final currentState = state as PlayerPlaying;
        emit(PlayerPaused(currentState.currentSong, currentState.position));
        await pauseSongUseCase.call();
        print('Emitted PlayerPaused for song: ${currentState.currentSong.songName}');
        return;
      }

      if (state is PlayerPaused) {
        // Tiếp tục bài hát
        final currentState = state as PlayerPaused;
        emit(PlayerPlaying(currentState.currentSong, currentState.position));
        await resumeSongUseCase.call();
        print('Emitted PlayerPlaying after resuming song: ${currentState.currentSong.songName}');
        return;
      }
    } catch (e) {
      emit(PlayerError("Cannot toggle play/pause: $e"));
      print('PlayerError: $e');
    }
  }
}

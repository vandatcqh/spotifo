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
  final AudioPlayer audioPlayer;
  SongEntity? _currentSong;
  PlayerCubit({
    required this.audioPlayer,
    required this.playSongUseCase,
    required this.pauseSongUseCase,
    required this.resumeSongUseCase,
    required this.seekSongUseCase,
  }) : super(PlayerInitial());

  Future<void> togglePlayPause(SongEntity song) async {
    try {
      // Nếu đang phát một bài hát khác, dừng và phát bài mới
      if (_currentSong?.id != song.id) {
        await audioPlayer.stop();
        await audioPlayer.setUrl(song.audioUrl);
        await audioPlayer.play();
        _currentSong = song;
        emit(PlayerPlaying(song, Duration.zero));
        return;
      }

      // Nếu đang pause, thực hiện resume
      if (state is PlayerPaused) {
        await audioPlayer.play();
        emit(PlayerPlaying(song, await audioPlayer.position));
        return;
      }

      // Nếu đang play, thực hiện pause
      if (state is PlayerPlaying) {
        await audioPlayer.pause();
        emit(PlayerPaused(song, await audioPlayer.position));
        return;
      }

      // Trường hợp còn lại (initial hoặc error), bắt đầu phát
      await audioPlayer.setUrl(song.audioUrl);
      await audioPlayer.play();
      _currentSong = song;
      emit(PlayerPlaying(song, Duration.zero));
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> pauseSong() async {
    if (state is PlayerPlaying && _currentSong != null) {
      await audioPlayer.pause();
      emit(PlayerPaused(_currentSong!, await audioPlayer.position));
    }
  }

  Future<void> resumeSong() async {
    if (state is PlayerPaused && _currentSong != null) {
      await audioPlayer.play();
      emit(PlayerPlaying(_currentSong!, await audioPlayer.position));
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}

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
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Future<void> togglePlayPause(SongEntity song) async {
    try {
      if (state is PlayerInitial || _currentSong?.id != song.id) {
        // Phát bài hát mới
        _currentSong = song;
        _currentPosition = Duration.zero;
        emit(PlayerPlaying(song, _currentPosition, _totalDuration));
        await playSongUseCase.call(song.audioUrl);

        // Lắng nghe luồng vị trí và thời lượng
        _listenToPositionStream();
        return;
      }

      if (state is PlayerPlaying) {
        // Tạm dừng bài hát
        final currentState = state as PlayerPlaying;
        emit(PlayerPaused(currentState.currentSong, currentState.position, currentState.totalDuration));
        await pauseSongUseCase.call();
        return;
      }

      if (state is PlayerPaused) {
        // Tiếp tục phát
        final currentState = state as PlayerPaused;
        emit(PlayerPlaying(currentState.currentSong, currentState.position, currentState.totalDuration));
        await resumeSongUseCase.call();
        return;
      }
    } catch (e) {
      emit(PlayerError("Cannot toggle play/pause: $e"));
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      if (_currentSong != null) {
        await seekSongUseCase.call(position);
        _currentPosition = position;
        if (state is PlayerPlaying) {
          emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        }
      }
    } catch (e) {
      emit(PlayerError("Cannot seek: $e"));
    }
  }

  void _listenToPositionStream() {
    // Lắng nghe vị trí hiện tại thông qua use case
    playSongUseCase.positionStream.listen((position) {
      _currentPosition = position;
      if (state is PlayerPlaying) {
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
      }
    });

    // Lắng nghe tổng thời gian thông qua use case
    playSongUseCase.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        if (state is PlayerPlaying) {
          emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        } else if (state is PlayerPaused) {
          final pausedState = state as PlayerPaused;
          emit(PlayerPaused(pausedState.currentSong, pausedState.position, _totalDuration));
        }
      }
    });
  }
}

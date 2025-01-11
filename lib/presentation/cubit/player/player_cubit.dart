import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/domain/usecases/set_speed.dart';
import 'package:spotifo/domain/usecases/set_volume.dart';
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
  final SetVolumeUseCase setVolumeUseCase;
  final SetSongSpeedUseCase setSongSpeedUseCase;
  double _currentVolume = 1.0;
  double _playbackSpeed = 1.0;
  PlayerCubit({
    required this.playSongUseCase,
    required this.pauseSongUseCase,
    required this.resumeSongUseCase,
    required this.seekSongUseCase,
    required this.setVolumeUseCase,
    required this.setSongSpeedUseCase,
  }) : super(PlayerInitial());

  SongEntity? _currentSong;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double get currentVolume => _currentVolume;
  double get playbackSpeed => _playbackSpeed;
  Future<void> togglePlayPause(SongEntity song) async {
    try {
      if (state is PlayerInitial || _currentSong?.id != song.id) {
        // Khi bài hát mới được phát
        listenToPositionStream();
        _currentSong = song;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        emit(PlayerPlaying(song, _currentPosition, _totalDuration));
        await playSongUseCase.call(song.audioUrl);

        // Đảm bảo lắng nghe lại trạng thái luồng
        listenToPositionStream();
      } else if (state is PlayerPlaying) {
        // Tạm dừng bài hát
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        await pauseSongUseCase.call();
      } else if (state is PlayerPaused) {
        // Tiếp tục phát
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        await resumeSongUseCase.call();
      }
    } catch (e) {
      emit(PlayerError("Error toggling play/pause: $e"));
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      _currentVolume = volume.clamp(0.0, 1.0); // Giới hạn giá trị từ 0.0 đến 1.0
      await setVolumeUseCase.call(_currentVolume);
      emit(state); // Phát lại trạng thái hiện tại để cập nhật giao diện
    } catch (e) {
      emit(PlayerError("Cannot set volume: $e"));
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
  Future<void> setPlaybackSpeed(double speed) async {
    try {
      _playbackSpeed = speed;
      await setSongSpeedUseCase(speed);
      if (state is PlayerPlaying) {
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
      } else if (state is PlayerPaused) {
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
      }
    } catch (e) {
      emit(PlayerError("Cannot set playback speed: $e"));
    }
  }

  Future<void> pauseSong() async {
    if (state is PlayerPlaying) {
      final currentState = state as PlayerPlaying;
      emit(PlayerPaused(currentState.currentSong, currentState.position, currentState.totalDuration));
      await pauseSongUseCase.call();
      print("Player paused.");
    }
  }

  void listenToPositionStream() {
    // Lắng nghe vị trí hiện tại từ use case
    playSongUseCase.positionStream.listen((position) {
      _currentPosition = position;
      if (state is PlayerPlaying) {
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
      } else if (state is PlayerPaused) {
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
      }
    });

    // Lắng nghe tổng thời gian từ use case
    playSongUseCase.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        if (state is PlayerPlaying) {
          emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        } else if (state is PlayerPaused) {
          emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        }
      }
    });
  }
}

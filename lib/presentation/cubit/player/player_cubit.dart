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

  bool _isFirstLoad = true; // Track if the song is on its first load

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
  Future<void> togglePlayPause(SongEntity song)   async {
    try {
      // print("state ${state}");

      if (state is PlayerInitial || _currentSong?.id != song.id) {

        // print("Playing song(before): ${_currentSong?.id}");
        _currentSong = song;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        listenToPositionStreamValue();
        _isFirstLoad = false; // Set first load flag
        emit(PlayerPlaying(song, _currentPosition, _totalDuration));
        // print("Playing song(after): ${_currentSong?.id}");
        await playSongUseCase.call(song.audioUrl);
        listenToPositionStreamValue();


      } else if (state is PlayerPlaying && _currentSong?.id == song.id) {

        // print("Playing song(before): ${_currentSong?.id}");
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        // print("Paused song(after): ${_currentSong?.id}");
        await pauseSongUseCase.call();

      }

      else if (state is PlayerPaused) {


        // print("Paused song(before): ${_currentSong?.id}");
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        // print("Playing song(after): ${_currentSong?.id}");
        await resumeSongUseCase.call();

      }

      // print("state(after): ${state}");

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
        // Update the current position
        await seekSongUseCase.call(position);
        _currentPosition = position;

        // Emit updated state if already playing

        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));

        if(state is PlayerPaused)
        {
          await resumeSongUseCase.call();
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
  Future<void> playSong(SongEntity song) async {
    // New song is being loaded

    print("Playing song(before): ${_currentSong?.id}");
    _currentSong = song;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;



    print("Playing song(after): ${_currentSong?.id}");

    emit(PlayerPlaying(song, _currentPosition, _totalDuration));

    await playSongUseCase.call(song.audioUrl);
    _isFirstLoad = false; // Set first load flag

    listenToPositionStream();
  }


  Future<void> pauseSong() async {
    if (state is PlayerPlaying) {
      final currentState = state as PlayerPlaying;
      emit(PlayerPaused(currentState.currentSong, currentState.position, currentState.totalDuration));
      await pauseSongUseCase.call();
      print("Player paused.");
    }
  }

  void listenToPositionStreamValue() {
    playSongUseCase.positionStream.listen((position) async {
      _currentPosition = position;

    });

    playSongUseCase.durationStream.listen((duration) {
      if (duration != null && duration != Duration.zero) {
        _totalDuration = duration;
      }
    });
  }

  void listenToPositionStream() {
    playSongUseCase.positionStream.listen((position) async {
      _currentPosition = position;
      _emitPlayerState();

      if (!isFirstLoad && _currentPosition >= _totalDuration) {
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        await pauseSongUseCase.call();
      }
    });

    playSongUseCase.durationStream.listen((duration) {
      if (duration != null && duration != Duration.zero) {
        _totalDuration = duration;
        _emitPlayerState();
      }
    });
  }

  void _emitPlayerState() {
    if (state is PlayerPlaying) {
      emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
    } else if (state is PlayerPaused) {
      emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
    }
  }

  Future<void> replay() async {
    try {
      if (_currentSong != null) {
        // Stop and reset the audio player if necessary
        await playSongUseCase.call(_currentSong!.audioUrl); // Reset the audio stream

        // Seek to the beginning of the song
        await seekSongUseCase.call(Duration.zero);
        _currentPosition = Duration.zero;

        // Replay the song
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
      }
    } catch (e) {
      emit(PlayerError("Cannot replay: $e"));
    }
  }


  bool get isFirstLoad => _isFirstLoad; // Expose first load status to the UI
}

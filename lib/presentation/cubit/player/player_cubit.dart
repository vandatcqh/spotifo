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

  bool _isFirstLoad = true; // Track if the song is on its first load

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
        // New song is being loaded
        listenToPositionStream();
        _currentSong = song;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;

        emit(PlayerPlaying(song, _currentPosition, _totalDuration));
        await playSongUseCase.call(song.audioUrl);
        _isFirstLoad = false; // Set first load flag
        // Ensure the streams are listened to again
        listenToPositionStream();
      } else if (state is PlayerPlaying) {
        // Pause the song
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        await pauseSongUseCase.call();
      } else if (state is PlayerPaused) {
        // Resume playback
        _isFirstLoad = false; // Reset first load flag
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        await resumeSongUseCase.call();
      }
    } catch (e) {
      emit(PlayerError("Error toggling play/pause: $e"));
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
          emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
          await resumeSongUseCase.call();
        }

      }
    } catch (e) {
      emit(PlayerError("Cannot seek: $e"));
    }
  }

  void listenToPositionStream() {
    playSongUseCase.positionStream.listen((position) async {
      _currentPosition = position;
      if (state is PlayerPlaying) {
        emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
      } else if (state is PlayerPaused) {
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
      }

      if(!isFirstLoad && _currentPosition >= _totalDuration)
      {
        emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        await pauseSongUseCase.call();
      }

    });

    playSongUseCase.durationStream.listen((duration) {
      if (duration != null && duration != Duration.zero) {
        _totalDuration = duration;
        if (state is PlayerPlaying) {
          emit(PlayerPlaying(_currentSong!, _currentPosition, _totalDuration));
        } else if (state is PlayerPaused) {
          emit(PlayerPaused(_currentSong!, _currentPosition, _totalDuration));
        }
      }
    });
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

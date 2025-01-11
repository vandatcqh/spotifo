import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spotifo/domain/entities/song_entity.dart';
import 'package:spotifo/domain/usecases/add_songs.dart';
import 'package:spotifo/domain/usecases/fetch_queue.dart';
import 'package:spotifo/domain/usecases/remove_from_queue.dart';
import 'package:spotifo/domain/usecases/shuffle_queue.dart';
import 'package:spotifo/domain/usecases/update_queue.dart';
import 'package:spotifo/presentation/cubit/queue/queue_state.dart';
import '../../../domain/usecases/add_queue.dart';
import '../player/player_cubit.dart';
import '../player/player_state.dart';

class QueueCubit extends Cubit<QueueState> {
  final FetchQueue fetchQueue;
  final AddToQueue addToQueue;
  final RemoveFromQueue removeFromQueue;
  final ShuffleQueue shuffleQueue;
  final UpdateQueue updateQueue;
  final AddSongsToQueueUseCase addSongsToQueueUseCase;

  QueueCubit({
    required this.fetchQueue,
    required this.addToQueue,
    required this.removeFromQueue,
    required this.shuffleQueue,
    required this.updateQueue,
    required this.addSongsToQueueUseCase,
  }) : super(QueueInitial());

  List<SongEntity> _queue = [];
  int _currentIndex = -1;

  Future<void> fetchQueueSongs() async {
    try {
      print("Fetching queue...");
      final queue = await fetchQueue();
      _queue = List.from(queue);
      print("Queue fetched successfully: ${_queue.length} songs");
      emit(QueueLoaded(queue: _queue, currentSong: _currentSong));
    } catch (e) {
      print("Error fetching queue: $e");
      emit(QueueError('Failed to fetch queue: $e'));
    }
  }

  Future<void> addSongToQueue(SongEntity song) async {
    try {
      print("Adding song to queue: ${song.songName}");
      await addToQueue(song);
      final updatedQueue = await fetchQueue(); // Fetch lại để đảm bảo đồng bộ
      _queue = List.from(updatedQueue);
      print("Song added successfully. Current queue length: ${_queue.length}");
      emit(QueueLoaded(queue: _queue, currentSong: _currentSong));
    } catch (e) {
      print("Error adding song to queue: $e");
      emit(QueueError('Failed to add song to queue: $e'));
    }
  }

  Future<void> removeSongFromQueue(SongEntity song) async {
    try {
      print("Removing song from queue: ${song.songName}");
      await removeFromQueue(song);
      final updatedQueue = await fetchQueue(); // Fetch lại để đảm bảo đồng bộ
      _queue = List.from(updatedQueue);
      print("Song removed successfully. Current queue length: ${_queue.length}");
      emit(QueueLoaded(queue: _queue, currentSong: _currentSong));
    } catch (e) {
      print("Error removing song from queue: $e");
      emit(QueueError('Failed to remove song from queue: $e'));
    }
  }

  Future<void> shuffleQueueSongs() async {
    try {
      print("Shuffling queue...");
      await shuffleQueue();
      final shuffledQueue = await fetchQueue(); // Fetch lại để đảm bảo đồng bộ
      _queue = List.from(shuffledQueue);
      print("Queue shuffled successfully.");
      emit(QueueLoaded(queue: _queue, currentSong: _currentSong));
    } catch (e) {
      print("Error shuffling queue: $e");
      emit(QueueError('Failed to shuffle queue: $e'));
    }
  }

  Future<void> updateQueueSongs(List<SongEntity> newQueue) async {
    try {
      print("Updating queue...");
      await updateQueue(newQueue);
      final updatedQueue = await fetchQueue(); // Fetch lại để đảm bảo đồng bộ
      _queue = List.from(updatedQueue);
      print("Queue updated successfully. Current queue length: ${_queue.length}");
      emit(QueueLoaded(queue: _queue, currentSong: _currentSong));
    } catch (e) {
      print("Error updating queue: $e");
      emit(QueueError('Failed to update queue: $e'));
    }
  }

  SongEntity? get _currentSong {
    if (_currentIndex >= 0 && _currentIndex < _queue.length) {
      return _queue[_currentIndex];
    }
    return null;
  }

  Future<void> playNextInQueue(PlayerCubit playerCubit) async {
    if (_queue.isNotEmpty) {
      // Cập nhật chỉ số bài hát tiếp theo
      _currentIndex = (_currentIndex + 1) % _queue.length;
      final nextSong = _queue[_currentIndex];
      print("Playing next song: ${nextSong.songName}");

      // Kiểm tra trạng thái PlayerCubit và xử lý
      if (playerCubit.state is PlayerPlaying) {
        // Nếu đang phát, dừng bài hiện tại trước khi chuyển
        await playerCubit.pauseSong();
      }
      // Chuyển sang bài hát mới và phát
      playerCubit.togglePlayPause(nextSong);

      // Cập nhật trạng thái QueueCubit
      emit(QueueLoaded(queue: _queue, currentSong: nextSong));
    } else {
      print("Queue is empty. Cannot play next song.");
    }
  }

  Future<void> playPreviousInQueue(PlayerCubit playerCubit) async {
    if (_queue.isNotEmpty) {
      // Cập nhật chỉ số bài hát trước đó
      _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
      final previousSong = _queue[_currentIndex];
      print("Playing previous song: ${previousSong.songName}");

      // Kiểm tra trạng thái PlayerCubit và xử lý
      if (playerCubit.state is PlayerPlaying) {
        // Nếu đang phát, dừng bài hiện tại trước khi chuyển
        await playerCubit.pauseSong();
      }
      // Chuyển sang bài hát mới và phát
      playerCubit.togglePlayPause(previousSong);

      // Cập nhật trạng thái QueueCubit
      emit(QueueLoaded(queue: _queue, currentSong: previousSong));
    } else {
      print("Queue is empty. Cannot play previous song.");
    }



  }


  Future<void> selectAndPlaySong(SongEntity song, PlayerCubit playerCubit) async {
    try {
      // Cập nhật chỉ mục của bài hát hiện tại
      final songIndex = _queue.indexOf(song);
      if (songIndex != -1) {
        _currentIndex = songIndex;
        print("Selected song: ${song.songName}");
        playerCubit.togglePlayPause(song); // Phát bài hát ngay lập tức
        emit(QueueLoaded(queue: _queue, currentSong: song));
      } else {
        print("Song not found in queue: ${song.songName}");
      }
    } catch (e) {
      print("Error selecting and playing song: $e");
      emit(QueueError("Error selecting and playing song: $e"));
    }
  }


  Future<void> addSongsToQueue(List<SongEntity> songs) async {
    try {
      print("Adding multiple songs to queue. Number of songs: ${songs.length}");
      await addSongsToQueueUseCase(songs);
      final updatedQueue = await fetchQueue(); // Fetch lại để đảm bảo đồng bộ
      _queue = List.from(updatedQueue);
      print("Songs added successfully. Current queue length: ${_queue.length}");
      emit(QueueLoaded(queue: _queue, currentSong: _currentSong));
    } catch (e) {
      print("Error adding songs to queue: $e");
      emit(QueueError("Failed to add songs to queue: $e"));
    }
  }
}

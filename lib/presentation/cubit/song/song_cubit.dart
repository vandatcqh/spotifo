import 'package:flutter_bloc/flutter_bloc.dart';
import 'song_state.dart';

/// Ví dụ:
/// - GetHotSongsUseCase getHotSongsUseCase
/// - SearchSongsByNameUseCase searchSongsByNameUseCase
/// - LikeSongUseCase likeSongUseCase
/// - UnlikeSongUseCase unlikeSongUseCase

class SongCubit extends Cubit<SongState> {
  // final GetHotSongsUseCase getHotSongsUseCase;
  // final SearchSongsByNameUseCase searchSongsByNameUseCase;
  // final LikeSongUseCase likeSongUseCase;
  // final UnlikeSongUseCase unlikeSongUseCase;

  SongCubit(
      // this.getHotSongsUseCase,
      // this.searchSongsByNameUseCase,
      // this.likeSongUseCase,
      // this.unlikeSongUseCase,
      ) : super(SongInitial());

  /// Lấy các bài hát đang hot
  Future<void> fetchHotSongs() async {
    emit(SongLoading());
    try {
      // final songs = await getHotSongsUseCase();
      // emit(SongHotLoaded(songs));
      // Giả lập
      await Future.delayed(const Duration(seconds: 1));
      emit(SongHotLoaded([]));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  /// Tìm kiếm bài hát
  Future<void> searchSongs(String keyword) async {
    emit(SongLoading());
    try {
      // final songs = await searchSongsByNameUseCase(keyword);
      // emit(SongSearchResultsLoaded(songs));
      // Giả lập
      await Future.delayed(const Duration(seconds: 1));
      emit(SongSearchResultsLoaded([]));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  /// Like bài hát
  Future<void> likeSong(String userId, String songId) async {
    try {
      // await likeSongUseCase(userId, songId);
      emit(SongLiked());
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  /// Unlike bài hát
  Future<void> unlikeSong(String userId, String songId) async {
    try {
      // await unlikeSongUseCase(userId, songId);
      emit(SongUnliked());
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}

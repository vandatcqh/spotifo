// presentation/cubit/favoriteSongs/favorite_songs_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorite_songs.dart';
import './favorite_songs_state.dart';
import '../../../domain/entities/song_entity.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  final GetFavoriteSongsUseCase getFavoriteSongsUseCase;

  FavoriteSongsCubit(this.getFavoriteSongsUseCase) : super(FavoriteSongsInitial());

  /// Lấy danh sách bài hát yêu thích
  Future<void> fetchFavoriteSongs() async {
    emit(FavoriteSongsLoading());
    try {
      final songs = await getFavoriteSongsUseCase.call();
      emit(FavoriteSongsLoaded(songs));
    } catch (e) {
      emit(FavoriteSongsError(e.toString()));
    }
  }

  /// Thêm bài hát vào danh sách yêu thích
  Future<void> addFavoriteSong(String songId) async {
    if (state is FavoriteSongsLoaded) {
      emit(FavoriteSongsLoading());
      try {
        await getFavoriteSongsUseCase.addFavoriteSong(songId);
        final songs = await getFavoriteSongsUseCase.call();
        emit(FavoriteSongsLoaded(songs));
      } catch (e) {
        emit(FavoriteSongsError(e.toString()));
      }
    }
  }

  /// Xóa bài hát khỏi danh sách yêu thích
  Future<void> removeFavoriteSong(String songId) async {
    if (state is FavoriteSongsLoaded) {
      emit(FavoriteSongsLoading());
      try {
        await getFavoriteSongsUseCase.removeFavoriteSong(songId);
        final songs = await getFavoriteSongsUseCase.call();
        emit(FavoriteSongsLoaded(songs));
      } catch (e) {
        emit(FavoriteSongsError(e.toString()));
      }
    }
  }

  /// Sắp xếp danh sách theo thứ tự A -> Z
  void sortSongsAscending() {
    if (state is! FavoriteSongsLoaded) return;

    final currentState = state as FavoriteSongsLoaded;
    final sortedSongs = List<SongEntity>.from(currentState.favoriteSongs)
      ..sort((a, b) => a.songName.compareTo(b.songName));

    emit(FavoriteSongsLoaded(sortedSongs));
  }

  /// Sắp xếp danh sách theo thứ tự Z -> A
  void sortSongsDescending() {
    if (state is! FavoriteSongsLoaded) return;

    final currentState = state as FavoriteSongsLoaded;
    final sortedSongs = List<SongEntity>.from(currentState.favoriteSongs)
      ..sort((a, b) => b.songName.compareTo(a.songName));

    emit(FavoriteSongsLoaded(sortedSongs));
  }
}

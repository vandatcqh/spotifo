// presentation/cubit/favoriteSongs/favorite_songs_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorite_songs.dart';
import '../../../domain/usecases/get_favorite_songs.dart'; // Import thêm use case cho add và remove
import './favorite_songs_state.dart';

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
    emit(FavoriteSongsLoading());
    try {
      await getFavoriteSongsUseCase.addFavoriteSong(songId);
      final songs = await getFavoriteSongsUseCase.call();
      emit(FavoriteSongsLoaded(songs));
    } catch (e) {
      emit(FavoriteSongsError(e.toString()));
    }
  }

  /// Xóa bài hát khỏi danh sách yêu thích
  Future<void> removeFavoriteSong(String songId) async {
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

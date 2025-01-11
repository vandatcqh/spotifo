// presentation/cubit/favoriteSongs/favorite_songs_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorite_songs.dart';
import './favorite_songs_state.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  final GetFavoriteSongsUseCase getFavoriteSongsUseCase;

  FavoriteSongsCubit(this.getFavoriteSongsUseCase) : super(FavoriteSongsInitial());

  Future<void> fetchFavoriteSongs() async {
    emit(FavoriteSongsLoading());
    try {
      final songs = await getFavoriteSongsUseCase();
      emit(FavoriteSongsLoaded(songs));
    } catch (e) {
      emit(FavoriteSongsError(e.toString()));
    }
  }
}

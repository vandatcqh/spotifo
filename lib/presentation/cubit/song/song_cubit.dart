import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:spotifo/presentation/cubit/song/song_state.dart';

import '../user/user_info_cubit.dart';
import '../../../domain/usecases/get_hot_songs.dart';

class SongInfoCubit extends Cubit<SongInfoState> {
  final GetHotSongsUseCase getHotSongsUseCase;

  SongInfoCubit({
    required this.getHotSongsUseCase,
  }) : super(SongInfoInitial());

  Future<void> fetchHotSongs() async {
    emit(SongInfoLoading());
    try {
      final songs = await getHotSongsUseCase.call();
      emit(SongHotSongsLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> fetchSongsByGenre(String genre) async {
    emit(SongInfoLoading());
    try {
      final songs = await getHotSongsUseCase.getSongsByGenre(genre);
      emit(SongByGenreLoaded(genre, songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}

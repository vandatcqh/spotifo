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
      print("Fetched songs: ${songs.length}"); // In ra số lượng bài hát
      emit(SongHotSongsLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

}
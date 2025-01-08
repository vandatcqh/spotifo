import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

/// - SearchSongsByNameUseCase searchSongsByNameUseCase
/// - SearchArtistsByNameUseCase searchArtistsByNameUseCase
/// - v.v.

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> searchAll(String keyword) async {
    emit(SearchLoading());
    try {
      // final songs = await searchSongsByNameUseCase(keyword);
      // final artists = await searchArtistsByNameUseCase(keyword);
      // emit(SearchResultsLoaded(songs, artists));
      // Giả lập:
      await Future.delayed(const Duration(seconds: 1));
      emit(SearchResultsLoaded([], []));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}

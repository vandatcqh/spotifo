import 'package:flutter_bloc/flutter_bloc.dart';
import 'artist_state.dart';

/// Ví dụ:
/// - GetHotArtistsUseCase getHotArtistsUseCase
/// - SearchArtistsByNameUseCase searchArtistsByNameUseCase

class ArtistCubit extends Cubit<ArtistState> {
  // final GetHotArtistsUseCase getHotArtistsUseCase;
  // final SearchArtistsByNameUseCase searchArtistsByNameUseCase;

  ArtistCubit(
      // this.getHotArtistsUseCase,
      // this.searchArtistsByNameUseCase
      ) : super(ArtistInitial());

  /// Lấy danh sách nghệ sĩ hot
  Future<void> fetchHotArtists() async {
    emit(ArtistLoading());
    try {
      // final artists = await getHotArtistsUseCase();
      // emit(ArtistHotLoaded(artists));
      // Giả lập
      await Future.delayed(const Duration(seconds: 1));
      emit(ArtistHotLoaded([]));
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }

  /// Tìm kiếm nghệ sĩ theo keyword
  Future<void> searchArtists(String keyword) async {
    emit(ArtistLoading());
    try {
      // final artists = await searchArtistsByNameUseCase(keyword);
      // emit(ArtistSearchResultsLoaded(artists));
      // Giả lập
      await Future.delayed(const Duration(seconds: 1));
      emit(ArtistSearchResultsLoaded([]));
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }
}

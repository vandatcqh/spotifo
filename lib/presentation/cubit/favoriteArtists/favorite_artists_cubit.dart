import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/artist_entity.dart';
import '../../../domain/usecases/get_favorite_artists.dart';

part 'favorite_artists_state.dart';

class FavoriteArtistsCubit extends Cubit<FavoriteArtistsState> {
  final GetFavoriteArtistsUseCase getFavoriteArtistsUseCase;

  FavoriteArtistsCubit(this.getFavoriteArtistsUseCase)
      : super(FavoriteArtistsInitial());

  /// Lấy danh sách nghệ sĩ yêu thích
  Future<void> fetchFavoriteArtists() async {
    emit(FavoriteArtistsLoading());
    try {
      final artists = await getFavoriteArtistsUseCase.call();
      emit(FavoriteArtistsLoaded(List.from(artists))); // Đảm bảo bất biến
    } catch (e) {
      emit(FavoriteArtistsError(e.toString()));
    }
  }

  /// Thêm nghệ sĩ vào danh sách yêu thích
  Future<void> addFavoriteArtist(ArtistEntity artist) async {
    if (state is! FavoriteArtistsLoaded) return;

    final currentState = state as FavoriteArtistsLoaded;
    final currentArtists = List<ArtistEntity>.from(currentState.favoriteArtists);

    emit(FavoriteArtistsLoading());
    try {
      // Gọi use case để thêm nghệ sĩ
      await getFavoriteArtistsUseCase.addFavoriteArtist(artist.id);
      artist.followers = artist.followers + 1;
      // Thêm nghệ sĩ vào danh sách hiện tại
      currentArtists.add(artist);

      emit(FavoriteArtistsLoaded(currentArtists));
    } catch (e) {
      emit(FavoriteArtistsError(e.toString()));
      emit(currentState); // Quay lại trạng thái trước đó nếu thất bại
    }
  }

  /// Xóa nghệ sĩ khỏi danh sách yêu thích
  Future<void> removeFavoriteArtist(String artistId) async {
    if (state is! FavoriteArtistsLoaded) return;

    final currentState = state as FavoriteArtistsLoaded;
    final currentArtists = List<ArtistEntity>.from(currentState.favoriteArtists);

    emit(FavoriteArtistsLoading());
    try {
      // Gọi use case để xóa nghệ sĩ
      await getFavoriteArtistsUseCase.removeFavoriteArtist(artistId);

      // Xóa nghệ sĩ khỏi danh sách hiện tại
      currentArtists.removeWhere((artist) => artist.id == artistId);

      emit(FavoriteArtistsLoaded(currentArtists));
    } catch (e) {
      emit(FavoriteArtistsError(e.toString()));
      emit(currentState); // Quay lại trạng thái trước đó nếu thất bại
    }
  }

  /// Sắp xếp danh sách theo thứ tự A -> Z
  void sortArtistsAscending() {
    if (state is! FavoriteArtistsLoaded) return;

    final currentState = state as FavoriteArtistsLoaded;
    final sortedArtists = List<ArtistEntity>.from(currentState.favoriteArtists)
      ..sort((a, b) => a.artistName.compareTo(b.artistName));

    emit(FavoriteArtistsLoaded(sortedArtists));
  }

  /// Sắp xếp danh sách theo thứ tự Z -> A
  void sortArtistsDescending() {
    if (state is! FavoriteArtistsLoaded) return;

    final currentState = state as FavoriteArtistsLoaded;
    final sortedArtists = List<ArtistEntity>.from(currentState.favoriteArtists)
      ..sort((a, b) => b.artistName.compareTo(a.artistName));

    emit(FavoriteArtistsLoaded(sortedArtists));
  }

}

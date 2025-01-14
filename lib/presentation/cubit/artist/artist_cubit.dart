// presentation/cubit/artist/artist_cubit.dart
import 'package:bloc/bloc.dart';
import 'artist_state.dart';
import '../../../domain/entities/song_entity.dart';
import '../../../domain/usecases/get_all_artists.dart';
import '../../../domain/usecases/get_songs_by_artist_id.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final GetAllArtistsUseCase getAllArtistsUseCase;
  final GetSongsByArtistIdUseCase getSongsByArtistIdUseCase;

  ArtistCubit(this.getAllArtistsUseCase, this.getSongsByArtistIdUseCase)
      : super(ArtistInitial());

  /// Lấy tất cả nghệ sĩ
  Future<void> fetchArtists() async {
    emit(ArtistLoading());
    try {
      final artists = await getAllArtistsUseCase();
      emit(ArtistLoaded(artists));
    } catch (e) {
      emit(ArtistError("Không thể tải danh sách nghệ sĩ."));
    }
  }

  /// Lấy danh sách bài hát theo ID nghệ sĩ
  Future<void> fetchSongsByArtistId(String artistId) async {
    emit(ArtistLoading());
    try {
      print("duma: $artistId");
      final songs = await getSongsByArtistIdUseCase(artistId);
      emit(SongsLoaded(songs));
    } catch (e) {
      emit(ArtistError("Không thể tải danh sách bài hát."));
    }
  }
}

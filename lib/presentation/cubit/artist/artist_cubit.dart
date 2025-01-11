// presentation/cubit/artist/artist_cubit.dart

import 'package:bloc/bloc.dart';
import 'artist_state.dart';
import '../../../domain/entities/artist_entity.dart';
import '../../../domain/usecases/get_hot_artists.dart';

class ArtistCubit extends Cubit<ArtistState> {
  final GetAllArtistsUseCase getAllArtistsUseCase;

  ArtistCubit(this.getAllArtistsUseCase) : super(ArtistInitial());

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
}

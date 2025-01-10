import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_genre.dart';
import '../../../domain/entities/genre_entity.dart';
import 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  final GetAllGenresUseCase getAllGenresUseCase;

  GenreCubit(this.getAllGenresUseCase) : super(GenreInitial());

  /// Fetches the list of genres from the use case
  Future<void> fetchGenres() async {
    try {
      final genres = await getAllGenresUseCase();
      emit(GenreLoaded(genres.map((e) => e.name).toList()));
    } catch (e) {
      emit(GenreError("Không thể tải danh sách thể loại."));
    }
  }

/// No longer manages selected genres
}

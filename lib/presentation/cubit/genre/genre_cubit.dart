import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_genre.dart';
import '../../../domain/entities/genre_entity.dart';
import 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  final GetAllGenresUseCase getAllGenresUseCase;

  GenreCubit(this.getAllGenresUseCase) : super(GenreInitial([]));

  /// Lấy danh sách thể loại từ usecase
  Future<void> fetchGenres() async {
    try {
      final genres = await getAllGenresUseCase();
      emit(GenreLoaded(genres.map((e) => e.name).toList())); // Chuyển GenreEntity thành danh sách tên
    } catch (e) {
      emit(GenreError("Không thể tải danh sách thể loại."));
    }
  }

  /// Toggle chọn/huỷ chọn 1 genre
  void toggleFavoriteGenre(String genre) {
    final currentList = List<String>.from(state.selectedGenres);
    if (currentList.contains(genre)) {
      currentList.remove(genre);
    } else {
      currentList.add(genre);
    }
    emit(GenreInitial(currentList));
  }

  /// Reset/clear danh sách đã chọn nếu cần
  void clear() {
    emit(GenreInitial([]));
  }
}

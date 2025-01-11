abstract class GenreState {
  const GenreState();
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<String> genres;

  GenreLoaded(this.genres);
}

class GenreError extends GenreState {
  final String message;

  GenreError(this.message);
}

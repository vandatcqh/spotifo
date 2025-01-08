abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final List<dynamic> songs;   // Hoặc List<SongEntity>
  final List<dynamic> artists; // Hoặc List<ArtistEntity>

  SearchResultsLoaded(this.songs, this.artists);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

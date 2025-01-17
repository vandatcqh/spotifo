// presentation/cubit/favoriteArtists/favorite_artists_state.dart
part of 'favorite_artists_cubit.dart';


abstract class FavoriteArtistsState extends Equatable {
  const FavoriteArtistsState();

  @override
  List<Object?> get props => [];
}

class FavoriteArtistsInitial extends FavoriteArtistsState {}

class FavoriteArtistsLoading extends FavoriteArtistsState {}

class FavoriteArtistsLoaded extends FavoriteArtistsState {
  final List<ArtistEntity> favoriteArtists;

  const FavoriteArtistsLoaded(this.favoriteArtists);

  @override
  List<Object?> get props => [favoriteArtists];
}

class FavoriteArtistsError extends FavoriteArtistsState {
  final String message;

  const FavoriteArtistsError(this.message);

  @override
  List<Object?> get props => [message];
}

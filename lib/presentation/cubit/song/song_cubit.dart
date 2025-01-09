/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'song_state.dart';

/// Ví dụ:
/// - GetHotSongsUseCase getHotSongsUseCase
/// - SearchSongsByNameUseCase searchSongsByNameUseCase
/// - LikeSongUseCase likeSongUseCase
/// - UnlikeSongUseCase unlikeSongUseCase

class SongCubit extends Cubit<SongState> {
  // final GetHotSongsUseCase getHotSongsUseCase;
  // final SearchSongsByNameUseCase searchSongsByNameUseCase;
  // final LikeSongUseCase likeSongUseCase;
  // final UnlikeSongUseCase unlikeSongUseCase;

  SongCubit(
      // this.getHotSongsUseCase,
      // this.searchSongsByNameUseCase,
      // this.likeSongUseCase,
      // this.unlikeSongUseCase,
      ) : super(SongInitial());

  /// Lấy các bài hát đang hot
  Future<void> fetchHotSongs() async {
    emit(SongLoading());
    try {
      // final songs = await getHotSongsUseCase();
      // emit(SongHotLoaded(songs));
      // Giả lập
      await Future.delayed(const Duration(seconds: 1));
      emit(SongHotLoaded([]));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  /// Tìm kiếm bài hát
  Future<void> searchSongs(String keyword) async {
    emit(SongLoading());
    try {
      // final songs = await searchSongsByNameUseCase(keyword);
      // emit(SongSearchResultsLoaded(songs));
      // Giả lập
      await Future.delayed(const Duration(seconds: 1));
      emit(SongSearchResultsLoaded([]));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  /// Like bài hát
  Future<void> likeSong(String userId, String songId) async {
    try {
      // await likeSongUseCase(userId, songId);
      emit(SongLiked());
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  /// Unlike bài hát
  Future<void> unlikeSong(String userId, String songId) async {
    try {
      // await unlikeSongUseCase(userId, songId);
      emit(SongUnliked());
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifo/domain/usecases/get_current_user.dart';
import 'package:spotifo/domain/usecases/get_hot_albums.dart';
import 'package:spotifo/domain/usecases/get_hot_artists.dart';
import 'package:spotifo/domain/usecases/get_hot_songs.dart';
import 'package:spotifo/domain/usecases/like_song.dart';
import 'package:spotifo/domain/usecases/search_songs_by_name.dart';
import 'package:spotifo/domain/usecases/unlike_song.dart';
import 'package:spotifo/presentation/cubit/song/song_state.dart';

import '../../../domain/entities/user_entity.dart';
import '../user/user_info_cubit.dart';

class SongInfoCubit extends Cubit<SongInfoState> {
  final GetHotAlbumsUseCase getHotAlbumsUseCase;
  final GetHotArtistsUseCase getHotArtistsUseCase;
  final GetHotSongsUseCase getHotSongsUseCase;
  final SearchSongsByNameUseCase searchSongsByNameUseCase;
  final LikeSongUseCase likeSongUseCase;
  final UnlikeSongUseCase unlikeSongUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  SongInfoCubit({
    required this.unlikeSongUseCase,
    required this.likeSongUseCase,
    required this.searchSongsByNameUseCase,
    required this.getHotAlbumsUseCase,
    required this.getHotArtistsUseCase,
    required this.getHotSongsUseCase,
    required this.getCurrentUserUseCase,
  }) : super(SongInfoInitial());

  Future<void> fetchHotAlbums() async {
    emit(SongInfoLoading());
    try {
      final albums = await getHotAlbumsUseCase.call();
      emit(SongHotAlbumsLoaded(albums));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> fetchHotArtists() async {
    emit(SongInfoLoading());
    try {
      final artists = await getHotArtistsUseCase.call();
      emit(SongHotArtistsLoaded(artists));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> fetchHotSongs() async {
    emit(SongInfoLoading());
    try {
      final songs = await getHotSongsUseCase.call();
      print("Fetched songs: ${songs.length}"); // In ra số lượng bài hát
      emit(SongHotSongsLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> searchSongs(String query) async {
    emit(SongInfoLoading());
    try {
      final searchResults = await searchSongsByNameUseCase.call(query);
      emit(SongSearchResultsLoaded(searchResults));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> likeSong(String songId) async {
    emit(SongInfoLoading());
    try {
      final user = await getCurrentUserUseCase.call();
      await likeSongUseCase.call(user!.userId,songId);
      emit(SongLiked());
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> unlikeSong(String songId) async {
    emit(SongInfoLoading());
    try {
      final user = await getCurrentUserUseCase.call();
      await unlikeSongUseCase.call(user!.userId,songId);
      emit(SongUnliked());
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}

// injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotifo/data/datasources/album_remote_datasource.dart';
import 'package:spotifo/data/datasources/artist_remote_datasource.dart';
import 'package:spotifo/data/datasources/song_remote_datasource.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';

// ------------------- //
//  Chỉ import Cubit  //
// ------------------- //
import 'data/repositories/music_repository_impl.dart';
import 'data/repositories/player_repository_impl.dart';
import 'domain/repositories/music_repository.dart';
import 'domain/repositories/player_repository.dart';
import 'domain/usecases/get_hot_albums.dart';
import 'domain/usecases/get_hot_artists.dart';
import 'domain/usecases/get_hot_songs.dart';
import 'domain/usecases/like_song.dart';
import 'domain/usecases/pause_song.dart';
import 'domain/usecases/play_song.dart';
import 'domain/usecases/resume_song.dart';
import 'domain/usecases/search_songs_by_name.dart';
import 'domain/usecases/seek_song.dart';
import 'domain/usecases/unlike_song.dart';
import 'presentation/cubit/auth/sign_in_cubit.dart';
import 'presentation/cubit/auth/sign_up_cubit.dart';
import 'presentation/cubit/user/user_info_cubit.dart';
import 'presentation/cubit/genre/genre_cubit.dart';

// ------------------- //
//    Import domain    //
// ------------------- //
import 'domain/usecases/sign_in.dart';
import 'domain/usecases/sign_up.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/get_all_genre.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/genre_repository.dart';

// ------------------- //
//    Import data      //
// ------------------- //
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/datasources/genre_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/genre_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  // --- Player ---
  sl.registerLazySingleton(() => AudioPlayer());
  // --- Data Sources ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(firebaseAuth: firebaseAuth),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(firestore: firebaseFirestore),
  );
  sl.registerLazySingleton<GenreRemoteDataSource>(
      () => GenreRemoteDataSource(firestore: firebaseFirestore),
  );
  sl.registerLazySingleton<SongRemoteDataSource>(
        () => SongRemoteDataSource(firestore: firebaseFirestore), // Đăng ký datasource
  );
  sl.registerLazySingleton<AlbumRemoteDataSource>(
        () => AlbumRemoteDataSource(firestore: firebaseFirestore), // Đăng ký datasource
  );
  sl.registerLazySingleton<ArtistRemoteDataSource>(
        () => ArtistRemoteDataSource(firestore: firebaseFirestore), // Đăng ký datasource
  );
  // --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      userRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<GenreRepository>(
      () => GenreRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MusicRepository>(
        () => MusicRepositoryImpl(
      firebaseFirestore,
      songRemoteDataSource: sl(),
      albumRemoteDataSource: sl(),
      artistRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PlayerRepository>(
        () => PlayerRepositoryImpl(sl()),
  );
  // --- UseCases ---
  sl.registerLazySingleton<SignInUseCase>(
        () => SignInUseCase(sl()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
        () => SignUpUseCase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
        () => SignOutUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllGenresUseCase>(
      () => GetAllGenresUseCase(sl()),
  );
  sl.registerLazySingleton<GetHotAlbumsUseCase>(
        () => GetHotAlbumsUseCase(sl()),
  );
  sl.registerLazySingleton<GetHotArtistsUseCase>(
        () => GetHotArtistsUseCase(sl()),
  );
  sl.registerLazySingleton<GetHotSongsUseCase>(
        () => GetHotSongsUseCase(sl()),
  );
  sl.registerLazySingleton<SearchSongsByNameUseCase>(
        () => SearchSongsByNameUseCase(sl()),
  );
  sl.registerLazySingleton<LikeSongUseCase>(
        () => LikeSongUseCase(sl()),
  );
  sl.registerLazySingleton<UnlikeSongUseCase>(
        () => UnlikeSongUseCase(sl()),
  );
  sl.registerLazySingleton(() => PlaySongUseCase(sl()));
  sl.registerLazySingleton(() => PauseSongUseCase(sl()));
  sl.registerLazySingleton(() => ResumeSongUseCase(sl()));
  sl.registerLazySingleton(() => SeekSongUseCase(sl()));
  // --- Cubits ---
  // Lưu ý: Dùng registerFactory nếu mỗi lần tạo mới Cubit
  //        Dùng registerLazySingleton nếu chỉ muốn một instance duy nhất
  sl.registerFactory<SignInCubit>(
        () => SignInCubit(signInUseCase: sl()),
  );
  sl.registerFactory<SignUpCubit>(
        () => SignUpCubit(signUpUseCase: sl()),
  );
  sl.registerFactory<UserInfoCubit>(
        () => UserInfoCubit(
      getCurrentUserUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );
  sl.registerFactory<GenreCubit>(
      () => GenreCubit(sl()),
  );
  sl.registerFactory<SongInfoCubit>(
        () => SongInfoCubit(
      getHotAlbumsUseCase: sl(),
      getHotArtistsUseCase: sl(),
      getHotSongsUseCase: sl(),
      searchSongsByNameUseCase: sl(),
      likeSongUseCase: sl(),
      unlikeSongUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
  sl.registerFactory(() => PlayerCubit(
    audioPlayer: AudioPlayer(),
    playSongUseCase: sl(),
    pauseSongUseCase: sl(),
    resumeSongUseCase: sl(),
    seekSongUseCase: sl(),
  ));
}

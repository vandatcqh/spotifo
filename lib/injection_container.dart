// injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
// ------------------- //
//  Import Cubits     //
// ------------------- //
import 'presentation/cubit/auth/sign_in_cubit.dart';
import 'presentation/cubit/auth/sign_up_cubit.dart';
import 'presentation/cubit/user/user_info_cubit.dart';
import 'presentation/cubit/genre/genre_cubit.dart';
import 'presentation/cubit/artist/artist_cubit.dart';
import 'presentation/cubit/favoriteSongs/favorite_songs_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/cubit/player/player_cubit.dart';
import 'presentation/cubit/favoriteArtists/favorite_artists_cubit.dart';

// ------------------- //
//    Import Domain    //
// ------------------- //
import 'domain/usecases/sign_in.dart';
import 'domain/usecases/sign_up.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/get_all_genre.dart';
import 'domain/usecases/update_user_profile.dart';
import 'domain/usecases/get_favorite_artists.dart';
import 'domain/usecases/get_favorite_songs.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/genre_repository.dart';
import 'domain/usecases/get_all_artists.dart';
import 'domain/repositories/artist_repository.dart';
import 'domain/usecases/pause_song.dart';
import 'domain/usecases/play_song.dart';
import 'domain/usecases/resume_song.dart';
import 'domain/usecases/seek_song.dart';
import 'domain/usecases/get_hot_songs.dart';
import 'domain/usecases/get_songs_by_artist_id.dart';
import 'domain/repositories/music_repository.dart';
import 'domain/repositories/player_repository.dart';

// ------------------- //
//    Import Data      //
// ------------------- //
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/datasources/genre_remote_datasource.dart';
import 'data/datasources/artist_remote_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/genre_repository_impl.dart';
import 'data/repositories/artist_repository_impl.dart';
import 'data/datasources/song_remote_datasource.dart';
import 'data/repositories/music_repository_impl.dart';
import 'data/repositories/player_repository_impl.dart';


final sl = GetIt.instance;

Future<void> init() async {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => AudioPlayer());
  // --- Data Sources ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(firebaseAuth: firebaseAuth),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(firestore: firebaseFirestore, firebaseAuth: firebaseAuth),
  );
  sl.registerLazySingleton<GenreRemoteDataSource>(
        () => GenreRemoteDataSource(firestore: firebaseFirestore),
  );
  sl.registerLazySingleton<ArtistRemoteDataSource>(
        () => ArtistRemoteDataSource(firestore: firebaseFirestore),
  );
  sl.registerLazySingleton<SongRemoteDataSource>(
        () => SongRemoteDataSource(firestore: firebaseFirestore),
  );

  // --- Repositories ---
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      authRemoteDataSource: sl(),
      userRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<GenreRepository>(
        () => GenreRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ArtistRepository>(() => ArtistRepositoryImpl(
    remoteDataSource: sl(),
    songRemoteDataSource: sl(), // Cung cấp SongRemoteDataSource
  ));
  sl.registerLazySingleton<MusicRepository>(
        () => MusicRepositoryImpl(
      firebaseFirestore,
      songRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<PlayerRepository>(
        () => PlayerRepositoryImpl(sl<AudioPlayer>()),
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
  sl.registerLazySingleton<GetAllArtistsUseCase>(
        () => GetAllArtistsUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateUserProfileUseCase>(
        () => UpdateUserProfileUseCase(sl()),
  );
  sl.registerLazySingleton<GetFavoriteArtistsUseCase>(
        () => GetFavoriteArtistsUseCase(sl(), sl()),
  );
  sl.registerLazySingleton<GetHotSongsUseCase>(
        () => GetHotSongsUseCase(sl()),
  );
  sl.registerLazySingleton<GetSongsByArtistIdUseCase>(
        () => GetSongsByArtistIdUseCase(sl()),
  );
  sl.registerLazySingleton(() => PlaySongUseCase(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => PauseSongUseCase(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => ResumeSongUseCase(sl<PlayerRepository>()));
  sl.registerLazySingleton(() => SeekSongUseCase(sl<PlayerRepository>()));
  sl.registerLazySingleton<GetFavoriteSongsUseCase>(
        () => GetFavoriteSongsUseCase(sl()),
  );
  // --- Cubits ---
  // Note:
  // - Use `registerFactory` for Cubits to ensure a new instance is created each time.
  // - Use `registerLazySingleton` if you prefer a single instance throughout the app.

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
      updateUserProfileUseCase: sl(),
    ),
  );
  sl.registerFactory<GenreCubit>(
        () => GenreCubit(sl()),
  );
  sl.registerFactory<ArtistCubit>(
        () => ArtistCubit(sl(), sl()),
  );
  sl.registerFactory<SongInfoCubit>(
        () => SongInfoCubit(
      getHotSongsUseCase: sl(),
    ),
  );
  sl.registerFactory<FavoriteSongsCubit>(
        () => FavoriteSongsCubit(sl()),
  );
  sl.registerFactory<FavoriteArtistsCubit>(
        () => FavoriteArtistsCubit(sl()),
  );
  sl.registerLazySingleton(() => PlayerCubit(
    playSongUseCase: sl(),
    pauseSongUseCase: sl(),
    resumeSongUseCase: sl(),
    seekSongUseCase: sl(),
  ));



}

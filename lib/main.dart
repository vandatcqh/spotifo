import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:spotifo/presentation/cubit/favoriteSongs/favorite_songs_cubit.dart';
import 'package:spotifo/presentation/cubit/genre/genre_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
<<<<<<< HEAD
import 'package:spotifo/presentation/screens/favorite_songs_screen.dart';
import 'package:spotifo/theme/theme_helper.dart';
=======
import 'package:spotifo/presentation/screens/library/favorite_artist_screen.dart';
import 'package:spotifo/presentation/screens/library/favorite_songs_screen.dart';
>>>>>>> thanh

import 'firebase_options.dart';

import 'presentation/cubit/user/user_info_cubit.dart';
import 'presentation/cubit/player/player_cubit.dart';
import 'presentation/cubit/favoriteArtists/favorite_artists_cubit.dart';
import 'presentation/cubit/artist/artist_cubit.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/library/libra.dart';

import 'presentation/screens/home_screen/home_screen.dart';
import 'presentation/screens/song_list_screen.dart';
import 'presentation/cubit/queue/queue_cubit.dart';
import 'presentation/screens/genre_song_screen.dart';

import 'injection_container.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {

          return MultiBlocProvider(
            providers: [
              BlocProvider<UserInfoCubit>(create: (_) => di.sl<UserInfoCubit>()),
              BlocProvider(create: (_) => di.sl<PlayerCubit>()),
              BlocProvider<FavoriteArtistsCubit>(create: (_) => di.sl<FavoriteArtistsCubit>()..fetchFavoriteArtists()),
              BlocProvider<ArtistCubit>(create: (_) => di.sl<ArtistCubit>()..fetchArtists()),
              BlocProvider<FavoriteSongsCubit>(create: (_) => di.sl<FavoriteSongsCubit>()..fetchFavoriteSongs()),
              BlocProvider<SongInfoCubit>(create: (_) => di.sl<SongInfoCubit>()..fetchHotSongs()),
              BlocProvider(create: (_) => di.sl<PlayerCubit>()),
              BlocProvider(create: (_) => di.sl<QueueCubit>()),
              BlocProvider(create: (_) => di.sl<GenreCubit>()),
              // Thêm các Cubit khác nếu cần
            ],
            child: MaterialApp(
              title: 'SPOTIFO',
              theme: theme.getThemeData(),
              //home: SplashScreen(),
              home: HomeScreen(),
              routes: {
                '/favorite_artists': (context) => const FavoriteArtistScreen(),
                '/favorite_songs': (context) => const FavoriteSongsScreen(),
                '/library': (context) => const LibraryScreen(),
                '/artists': (context) => const FavoriteArtistScreen(),
                '/home' : (context) => const HomeScreen(),
                '/your_playlist': (context) => const SongListScreen(),
                '/profile': (context) => const UserInfoScreen(),
                // Thêm các route khác nếu cần
              },
              onGenerateRoute: (settings) {
                if (settings.name == '/genre_song') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => GenreSongsScreen(genreName: args['genreName']),
                  );
                }
                return null; // Xử lý mặc định
              },
            ),
          );
    });

  }
}

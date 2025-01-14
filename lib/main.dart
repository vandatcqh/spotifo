import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:spotifo/presentation/cubit/favoriteSongs/favorite_songs_cubit.dart';
import 'package:spotifo/presentation/cubit/song/song_cubit.dart';
import 'package:spotifo/presentation/screens/favorite_songs_screen.dart';

import 'firebase_options.dart';

import 'presentation/cubit/user/user_info_cubit.dart';
import 'presentation/cubit/player/player_cubit.dart';
import 'presentation/cubit/favoriteArtists/favorite_artists_cubit.dart';
import 'presentation/cubit/artist/artist_cubit.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/favorite_artist_screen.dart';
import 'presentation/screens/libra.dart';

import 'presentation/screens/list_artist_screen.dart';
import 'presentation/screens/home_screen/home_screen.dart';
import 'presentation/screens/song_list_screen.dart';
import 'presentation/cubit/queue/queue_cubit.dart';
import 'presentation/screens/splash_screen.dart';

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
              // Thêm các Cubit khác nếu cần
            ],
            child: MaterialApp(
              title: 'Flutter Clean Architecture với Firebase',
              theme: _lightTheme(),
              darkTheme: _darkTheme(),
              home: SplashScreen(),
              //home: HomeScreen(),
              routes: {
                '/favorite_artists': (context) => const FavoriteArtistScreen(),
                '/favorite_songs': (context) => const FavoriteSongsScreen(),
                '/libra': (context) => const LibraryScreen(),
                '/artists': (context) => const ListArtistScreen(),
                '/home' : (context) => const HomeScreen(),
                '/your_playlist': (context) => const SongListScreen()
                // Thêm các route khác nếu cần
              },
            ),
          );
    });

  }

  ThemeData _lightTheme() {
    // Tương tự như code bạn đã viết
    return ThemeData(
      primaryColor: const Color(0xFF011C39),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF324A59),
        onPrimary: Color(0xFFFFBB55),
        secondary: Color(0xFF143D5D),
        onSecondary: Color(0xFFE7D6C6),
        surface: Color(0xFFF6F4E7),
        onSurface: Color(0xFF173A5B),
        error: Color(0xFFC44D4F),
        onError: Color(0xFFF6F4E7),
      ),
      textTheme: Typography.material2021().black,
    );
  }

  ThemeData _darkTheme() {
    // Tương tự như code bạn đã viết
    return ThemeData(
      primaryColor: const Color(0xFFE7D6C6),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE7D6C6),
        onPrimary: Color(0xFF0E3A60),
        secondary: Color(0xFFF6F4E7),
        onSecondary: Color(0xFF173A5B),
        surface: Color(0xFF143D5D),
        onSurface: Color(0xFFF6F4E7),
        error: Color(0xFFC44D4F),
        onError: Color(0xFFF6F4E7),
      ),
      textTheme: Typography.material2021().white,
    );
  }
}

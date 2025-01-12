import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'presentation/cubit/user/user_info_cubit.dart';
import 'presentation/cubit/player/player_cubit.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/list_artist_screen.dart';
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
              BlocProvider<UserInfoCubit>(
                create: (_) => di.sl<UserInfoCubit>(),
              ),
              BlocProvider(create: (_) => di.sl<PlayerCubit>()),
              // Thêm các Cubit khác nếu cần
            ],
            child: MaterialApp(
              title: 'Flutter Clean Architecture với Firebase',
              theme: _lightTheme(),
              darkTheme: _darkTheme(),
              home: SplashScreen(),
              routes: {
                '/artists': (context) => const ListArtistScreen(),
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

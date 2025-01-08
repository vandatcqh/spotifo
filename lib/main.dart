// main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/screens/sign_up_screen.dart';
import 'presentation/screens/sign_in_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Không thêm các cấu hình theme phức tạp để giữ cho ví dụ đơn giản
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Architecture với Firebase',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: SignInScreen(), // Hiển thị màn hình đăng ký khi khởi động
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF011C39), // Primary color
      colorScheme: const ColorScheme(
        primary: Color(0xFF324A59), // Primary color
        onPrimary: Color(0xFFFFBB55), // Primary text color
        secondary: Color(0xFF143D5D), // Secondary color
        onSecondary: Color(0xFFE7D6C6), // Secondary text color
        surface: Color(0xFFF6F4E7), // Surface color
        onSurface: Color(0xFF173A5B), // On surface text color
        error: Color(0xFFC44D4F), // Error color
        onError: Color(0xFFF6F4E7), // Error text color
        // tertiary: Color(0xFFE2FFE8),
        // onTertiary: Color(0xFF32B751),
        // surfaceDim: Color(0xFF98A4AC),
        // outline: Color(0xFFEFEFEF),
        brightness: Brightness.light, // Brightness of the theme
      ),
      textTheme: Typography.material2021().black,
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      primaryColor: const Color(0xFFE7D6C6), // Primary color
      colorScheme: const ColorScheme(
        primary: Color(0xFFE7D6C6), // Primary color
        onPrimary: Color(0xFF0E3A60), // Primary text color
        secondary: Color(0xFFF6F4E7), // Secondary color
        onSecondary: Color(0xFF173A5B), // Secondary text color
        surface: Color(0xFF143D5D), // Surface color
        onSurface: Color(0xFFF6F4E7), // On surface text color
        error: Color(0xFFC44D4F), // Error color
        onError: Color(0xFFF6F4E7), // Error text color
        // tertiary: Color(0xFFE2FFE8),
        // onTertiary: Color(0xFF32B751),
        // surfaceDim: Color(0xFF98A4AC),
        // outline: Color(0xFFEFEFEF),
        brightness: Brightness.dark, // Set theme to dark mode
      ),
      textTheme: Typography.material2021().white,
    );
  }
}


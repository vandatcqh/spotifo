import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to SignInScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.orange.shade50, // Background color similar to your app theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Music Icon or Image
            Container(
              height: 20.h,
              width: 20.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/music_icon.png'), // Replace with your actual image asset
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // App Name
            Text(
              "Ordinary Music",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

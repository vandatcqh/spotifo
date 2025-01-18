import 'package:flutter/material.dart';

import 'package:spotifo/presentation/screens/home_screen/home_screen_content.dart';

import '../../../core/app_export.dart';
import '../../components/svg.dart';
import '../library/libra.dart';
import '../profile_screen.dart';
import '../search_screen.dart';

class NavigationScreen {
  NavigationScreen({required this.icon, required this.label});
  String icon;
  String label;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<NavigationScreen> navigations = [
    NavigationScreen(
      icon: "assets/svgs/heroicons-solid/home.svg",
      label: "Home",
    ),
    NavigationScreen(
      icon: "assets/svgs/heroicons-solid/user-circle.svg",
      label: "Profile",
    ),
    NavigationScreen(
      icon: "assets/svgs/heroicons-solid/magnifying-glass.svg",
      label: "Search",
    ),
    NavigationScreen(
      icon: "assets/svgs/heroicons-solid/rectangle-stack.svg",
      label: "Library",
    ),
  ];

  final List<Widget> screens = [
    const HomeScreenContent(),
    const UserInfoScreen(),
    const CloudFunctionTestScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          navigations[_currentIndex].label,
          style: textTheme.headlineMedium?.withColor(colorTheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorTheme.surface,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          elevation: 0,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: List.generate(navigations.length, (index) {
            return BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: SVG(navigations[index].icon, size: 4.h, color: _currentIndex == index ? colorTheme.onSurface : colorTheme.onSecondary),
              ),
              label: navigations[index].label,
            );
          }),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

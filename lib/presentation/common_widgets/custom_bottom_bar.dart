import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../components/svg.dart';

enum CustomBottomBarType { home, profile, search, library }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, this.onChanged, this.type = CustomBottomBarType.home});

  Function(CustomBottomBarType)? onChanged;
  CustomBottomBarType type;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarItem {
  CustomBottomBarItem({required this.icon, required this.type});
  String icon;
  CustomBottomBarType type;
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<CustomBottomBarItem> bottomMenuList = [
    CustomBottomBarItem(
      icon: "assets/svgs/heroicons-solid/home.svg",
      type: CustomBottomBarType.home,
    ),
    CustomBottomBarItem(
      icon: "assets/svgs/heroicons-solid/user-circle.svg",
      type: CustomBottomBarType.profile,
    ),
    CustomBottomBarItem(
      icon: "assets/svgs/heroicons-solid/magnifying-glass.svg",
      type: CustomBottomBarType.search,
    ),
    CustomBottomBarItem(
      icon: "assets/svgs/heroicons-solid/rectangle-stack.svg",
      type: CustomBottomBarType.library,
    )
  ];

  @override
  Widget build(BuildContext context) {
    selectedIndex = widget.type.index;
    return Container(
      decoration: BoxDecoration(
        color: colorTheme.surface,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: SVG(bottomMenuList[index].icon,
                  size: 4.h,
                  color: selectedIndex == index
                      ? colorTheme.onSurface
                      : colorTheme.onSecondary),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          if (widget.onChanged != null) {
            widget.onChanged?.call(bottomMenuList[index].type);
          } else {
            switch (bottomMenuList[index].type) {
              case CustomBottomBarType.home:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case CustomBottomBarType.profile:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
              case CustomBottomBarType.search:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case CustomBottomBarType.library:
                Navigator.pushReplacementNamed(context, '/your_playlist');
                break;
            }
          }
          setState(() {});
        },
      ),
    );
  }
}

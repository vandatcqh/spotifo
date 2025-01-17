import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../components/svg.dart';

enum BottomBarEnum { home, profile, search, library }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: "assets/svgs/heroicons-solid/home.svg",
      type: BottomBarEnum.home,
    ),
    BottomMenuModel(
      icon: "assets/svgs/heroicons-solid/user-circle.svg",
      type: BottomBarEnum.profile,
    ),
    BottomMenuModel(
      icon: "assets/svgs/heroicons-solid/magnifying-glass.svg",
      type: BottomBarEnum.search,
    ),
    BottomMenuModel(
      icon: "assets/svgs/heroicons-solid/rectangle-stack.svg",
      type: BottomBarEnum.library,
    )
  ];

  @override
  Widget build(BuildContext context) {
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
              padding:  EdgeInsets.symmetric(vertical: 4.h),
              child: SVG(bottomMenuList[index].icon,
                  size: 4.h, color: selectedIndex == index ? colorTheme.onSurface : colorTheme.onSecondary),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel({required this.icon, required this.type});

  String icon;
  BottomBarEnum type;
}

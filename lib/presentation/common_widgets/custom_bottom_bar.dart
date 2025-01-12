import 'package:flutter/material.dart';
import '../../core/app_export.dart';


enum BottomBarEnum {
  HeroIconsSolidHome,
  HeroIconsSolidUserCircle,
  Search,
  HeroIconsSolidRectangleStack
}

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
      icon: ImageConstant.imgHeroiconssolidHome,
      activeIcon: ImageConstant.imgHeroiconssolidHome,
      type: BottomBarEnum.HeroIconsSolidHome,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgHeroiconssolidUsercircle,
      activeIcon: ImageConstant.imgHeroiconssolidUsercircle,
      type: BottomBarEnum.HeroIconsSolidUserCircle,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgSearch,
      activeIcon: ImageConstant.imgSearch,
      type: BottomBarEnum.Search,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgHeroiconssolidRectanglestack,
      activeIcon: ImageConstant.imgHeroiconssolidRectanglestack,
      type: BottomBarEnum.HeroIconsSolidRectangleStack,
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
            icon: CustomImageView(
              imagePath: bottomMenuList[index].icon,
              height: 32.h,
              width: 34.h,
              color: colorTheme.surface,
            ),

            activeIcon: CustomImageView(
              imagePath: bottomMenuList[index].activeIcon,
              height: 32.h,
              width: 34.h,
              color: colorTheme.surface,
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
  BottomMenuModel(
      {required this.icon, required this.activeIcon, required this.type});

  String icon;
  String activeIcon;
  BottomBarEnum type;
}


class Defaultwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}

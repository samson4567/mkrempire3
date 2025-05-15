import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/navController.dart';
import 'package:mkrempire/config/app_colors.dart';

import '../../../app/controllers/profile_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  Future load() async {
    await Get.find<ProfileController>().getUserProfile();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NavigationController());
    return GetBuilder<AppController>(builder: (appController) {
      return GetBuilder<NavigationController>(builder: (controller) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return Scaffold(
            body: controller.currentScreen, // Display the selected screen
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedIndex,
              onTap: controller.changeScreen,
              // Use Theme.of(context) instead of Get.isDarkMode
              selectedItemColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.tertiaryColor
                  : AppColors.mainColor,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                    icon: svg('home', 30,
                        isSelected: controller.selectedIndex == 0),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: svg('airtime2cash', 28,
                        isSelected: controller.selectedIndex == 1),
                    label: 'Bills'),
                BottomNavigationBarItem(
                    icon: svg('card', 35,
                        isSelected: controller.selectedIndex == 2),
                    label: 'Card'),
                BottomNavigationBarItem(
                    icon: svg('giftcard', 30,
                        isSelected: controller.selectedIndex == 3),
                    label: 'Giftcard'),
                BottomNavigationBarItem(
                    icon: svg('more', 30,
                        isSelected: controller.selectedIndex == 4),
                    label: 'More'),
              ],
            ),
          );
        });
      });
    });
  }

  // Updated svg method that uses Theme.of(context) to detect theme changes
  Widget svg(String svg, double size, {bool isSelected = false}) => Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SvgPicture.asset(
            'assets/svgs/$svg.svg',
            height: size,
            width: size,
            color: isSelected
                ? (isDark ? AppColors.tertiaryColor : AppColors.mainColor)
                : Colors.grey,
          );
        },
      );
}

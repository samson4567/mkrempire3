import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:mkrempire/resources/screens/home_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(seconds: 5));
    //  Get.offAllNamed(RoutesName.loginScreen);
    print(
        ".isUserLoggedIn : ${HiveHelper.read(Keys.token).toString().isNotEmpty}\n" +
            ".isUserOnboarded : ${HiveHelper.read(Keys.onBoarded)}\n"
        // "authController.isUserLoggedIn : ${authController.isUserLoggedIn}\n"
        );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // Get.offAllNamed(RoutesName.bottomNavBar);
    if (HiveHelper.read(Keys.onBoarded) == null) {
      Get.offAllNamed(RoutesName.onbordingScreen);
    } else if ((HiveHelper.read(Keys.token)?.toString().isNotEmpty ?? false)) {
      Get.offAllNamed(RoutesName.pinScreen);
    } else {
      Get.offAllNamed(RoutesName.loginScreen);
    }
    // }
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
      body: Get.isDarkMode
          ? Center(
              child: Image.asset('assets/images/white_logo.png')
                  .animate()
                  .scale(delay: 1000.ms) // runs after fade.,
              )
          : Center(
              child: Image.asset('assets/images/white_logo.png')
                  .animate()
                  .scale(delay: 1000.ms) // runs after fade.,
              ),
    );
  }
}

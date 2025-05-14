import 'package:flutter/material.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();
    print(
        "authController.isUserLoggedIn : ${HiveHelper.read(Keys.token).toString().isNotEmpty}\n" +
            "authController.isUserOnboarded : ${HiveHelper.read(Keys.onBoarded)}\n"
        // "authController.isUserLoggedIn : ${authController.isUserLoggedIn}\n"
        );

    // Redirect to onboarding if the user has not completed it
    if (HiveHelper.read(Keys.onBoarded) != true) {
      HiveHelper.write(Keys.onBoarded, true);
      return RouteSettings(name: RoutesName.onbordingScreen);
    }

    // // Redirect to login if the user is not logged in
    // if ( HiveHelper.read(Keys.token).toString().isNotEmpty) {
    // return RouteSettings(name: RoutesName.loginScreen);
    // }else{
    //     return RouteSettings(name: RoutesName.pinScreen);
    // }

    // // Redirect to PIN screen if the user is logged in but hasn't set a PIN
    // // (Assuming you have a condition like `authController.isPinSet` in your AuthController)
    // if (authController.isUserLoggedIn) {
    //   return RouteSettings(name: RoutesName.pinScreen);
    // }

    // Redirect to verification if the user is not verified
    // if (!authController.isUserVerified) {
    //   return RouteSettings(name: RoutesName.verificationListScreen);
    // }

    // Allow navigation if all conditions are met
    return null;
  }
}

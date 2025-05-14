import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find<AppController>();
  // -------------- check internet connectivity-----------
  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.dialog(
        const CustomAppDialog(),
        barrierDismissible:
            false, // Prevent the user from closing the dialog by tapping outside
      );
    } else {
      // Dismiss the dialog if it's currently displayed
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  //-------------------Handle app theme----------------
  int selectedIndex = 0;
  isDarkMode() {
    return HiveHelper.read(Keys.isDark) ?? false;
  }

  onChanged(val) {
    HiveHelper.write(Keys.isDark, val);
    updateTheme();
  }

  bool isScreenDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  ThemeMode themeManager() {
    return HiveHelper.read(Keys.isDark) != null
        ? HiveHelper.read(Keys.isDark) == true
            ? ThemeMode.dark
            : ThemeMode.light
        : ThemeMode.system;
  }

  void updateTheme() {
    Get.changeThemeMode(themeManager());
    isDarkMode();
    update();
  }

//------------------GET APP CONFIG----------------------
  // bool isLoading = false;
  // Future getAppConfig() async {
  //   isLoading = true;
  //   update();
  //   http.Response response = await AppControllerRepo.getAppConfig();
  //   isLoading = false;
  //   update();
  //   var data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     if (data['status'] == 'success') {
  //       HiveHelper.write(Keys.baseCurrency, data['message']['base_currency']);
  //       // String baseColor = data['message']['primary_color'];
  //       // String sedondaryColor = data['message']['secondary_color'];
  //       // AppColors.mainColor = HexColor(baseColor);
  //       // AppColors.blackColor = HexColor(sedondaryColor);
  //       update();
  //     } else {
  //       ApiStatus.checkStatus(data['status'], data['message']);
  //     }
  //   } else {
  //     Helpers.showSnackBar(msg: '${data['message']}');
  //   }
  // }

//-------------------GET LANGUAGE--------------------
  // List<Language> languageList = [];
  // Future getLanguageList() async {
  //   isLoading = true;
  //   update();
  //   http.Response response = await AppControllerRepo.getLanguageList();
  //   languageList.clear();
  //   isLoading = false;
  //   update();
  //   var data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     if (data['status'] == 'success') {
  //       languageList.addAll(LanguageModel.fromJson(data).message!.languages!);
  //       update();
  //     } else {
  //       ApiStatus.checkStatus(data['status'], data['message']);
  //     }
  //   } else {
  //     Helpers.showSnackBar(msg: '${data['message']}');
  //   }
  // }

  // Future getLanguageListBuyId({required String id}) async {
  //   Get.find<ProfileController>().isUpdateProfile = true;
  //   Get.find<ProfileController>().update();
  //   http.Response response = await AppControllerRepo.getLanguageById(id: id);
  //   Get.find<ProfileController>().isUpdateProfile = false;
  //   Get.find<ProfileController>().update();
  //   var data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     if (data['status'] == 'success') {
  //       if (data['message'] != null && data['message'] is Map) {
  //         HiveHelper.write(Keys.languageData, data['message']);
  //         update();
  //       }
  //       update();
  //     } else {
  //       ApiStatus.checkStatus(data['status'], data['message']);
  //     }
  //   } else {
  //     Helpers.showSnackBar(msg: '${data['message']}');
  //   }
  // }
}

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

class CustomAppDialog extends StatelessWidget {
  const CustomAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        return;
      },
      child: AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie.asset(
            //   'assets/json/no_internet.json', // Replace with your image path
            //   height: 150.h,
            //   width: 150.w,
            // ),
            Text(
              'No Internet!!! Please check your connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

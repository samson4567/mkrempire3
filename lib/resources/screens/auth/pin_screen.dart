import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/config/app_contants.dart';
import 'package:mkrempire/resources/screens/auth/login_screen.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/routes/api_endpoints.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';

import '../../../app/controllers/app_controller.dart';
import '../../widgets/custom_app_button.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String pin = "";
  final LocalAuthentication auth = LocalAuthentication();
  final authController = Get.find<AuthController>();
  String name = HiveHelper.read(Keys.firstName);

  void _login() {
    // HiveHelper.cleanall()
    authController.singInPin = pin;
    authController.singInEmailVal = HiveHelper.read(Keys.userEmail);
    authController.update();
    authController.loginWithPin(context);
  }

  void _addDigit(String digit) {
    if (pin.length == 4) {
      _login();
    }
    if (pin.length < 4) {
      setState(() {
        pin += digit;
      });
      if (pin.length >= 4) {
        authController.singInPin = pin;
        _login();
      }
    }
  }

  void _removeDigit() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  Future<void> _authenticate(context) async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        // Handle successful authentication
        CustomDialog.showSuccess(
            buttonAction: () => Get.toNamed(RoutesName.bottomNavBar),
            context: context,
            message: 'Authentication Successful',
            buttonText: 'Continue');
      } else {
        CustomDialog.showError(
            buttonAction: () => Get.toNamed(RoutesName.bottomNavBar),
            context: context,
            message: 'Authentication Failed',
            buttonText: 'Back');
      }
    } catch (e) {
      // Handle errors
      CustomDialog.showError(
          context: context,
          message: 'Biometrics is not available on this Device',
          buttonText: 'Back');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final profileImage = "${HiveHelper.read(Keys.user)['image']}";
    return GetBuilder<AppController>(builder: (appController) {
      // print( Get.isDarkMode == true);
      return Scaffold(
        // backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.only(bottom: 150, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(
                  //   child: Image.network('${ApiEndpoints.baseUrl}/${profileImage}'),
                  // ),
                  Text(name.toUpperCase(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      // child:  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            "Please enter your pin to access your mkr empire account. Not $name ? ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                          InkWell(
                            onTap: () async {
                              HiveHelper.remove(Keys.token);
                              await Get.offAll(() => LoginScreen());
                            },
                            child: Text("log out",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue)),
                          )
                        ],
                        // )
                      )),
                  Obx(() {
                    return authController.isLoading.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CustomLoading(),
                                ),
                              ])
                        : Container(
                            width: 200.w,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.mainColor.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(22)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: index < pin.length
                                        ? Colors.black
                                        : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ));
                  }),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 40,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  String label;
                  if (index < 9) {
                    label = "${index + 1}";
                  } else if (index == 9) {
                    label = "biometrics";
                  } else if (index == 10) {
                    label = "0";
                  } else {
                    label = "⌫";
                  }
                  return GestureDetector(
                    onTap: () {
                      if (label == "⌫") {
                        _removeDigit();
                      } else if (label.isNotEmpty) {
                        _addDigit(label);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode == true
                            ? Colors.black.withAlpha(22)
                            : Colors.grey.withAlpha(22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: label == 'biometrics'
                          ? IconButton(
                              icon: const Icon(Icons.fingerprint,
                                  size: 40, color: Colors.blue),
                              onPressed: () => _authenticate(context))
                          : Text(label,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                // color: //Get.isDarkMode
                                // Colors.black
                                // : Colors.black,
                              )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

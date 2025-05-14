import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/custom_app_button.dart';
import '../../widgets/custom_textfield.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final AuthController authController = Get.find<AuthController>();
  var authPinVal = ''.obs;
  var confirmauthPinVal = ''.obs;

  @override
  Widget build(BuildContext context) {
    final firstname = HiveHelper.read(Keys.firstName);
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: const CustomAppBar(
            title: 'Set your transaction pin', showBackIcon: false),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                padding:
                    EdgeInsets.only(bottom: 150, left: 16, right: 16, top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/reset-password.png',
                          width: 170,
                          height: 170,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // Gap(20),
                    // Text('$firstname'.toUpperCase(),
                    //     style: TextStyle(
                    //         fontSize: 24, fontWeight: FontWeight.bold)),
                    Gap(30),
                    Text(
                      "Please set your pin to access your mkrempire account and make seamless transactions ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "New Pin",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Gap(10),
                    Obx(() => CustomTextField(
                          maxLength: 4,
                          hintText: 'Enter New Pin',
                          keyboardType: TextInputType.number,
                          controller: authController.authPinController.value,
                          onChanged: (v) {
                            authPinVal.value = v;
                          },
                        )),
                    Gap(20),
                    Text(
                      "Confirm Pin",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Gap(10),
                    Obx(() => CustomTextField(
                        maxLength: 4,
                        hintText: 'Confirm Pin',
                        keyboardType: TextInputType.number,
                        controller:
                            authController.confirmauthPinController.value,
                        onChanged: (v) {
                          confirmauthPinVal.value = v;
                        })),
                    Gap(20),
                    Obx(() => Container(
                          color: Colors.transparent,
                          child: CustomAppButton(
                            isLoading: authController.isResetting.value,
                            text: "Set Pin",
                            bgColor: authPinVal.value.isEmpty ||
                                    confirmauthPinVal.value.isEmpty
                                ? Get.isDarkMode
                                    ? AppColors.secondaryColor.withOpacity(0.3)
                                    : AppColors.mainColor.withOpacity(0.3)
                                : Get.isDarkMode
                                    ? AppColors.secondaryColor
                                    : AppColors.mainColor,
                            textColor: Colors.white,
                            onTap: authPinVal.value.isEmpty ||
                                    confirmauthPinVal.value.isEmpty
                                ? null
                                : () async {
                                    if (confirmauthPinVal.value !=
                                        authPinVal.value) {
                                      return CustomDialog.showError(
                                          message: "Pin MisMatch",
                                          buttonText: "close",
                                          context: context);
                                    }
                                    await authController.authResetPin(
                                      pin: authPinVal.value,
                                    );
                                  },
                          ),
                        )),
                  ],
                ),
              ))
            ]));
  }
}

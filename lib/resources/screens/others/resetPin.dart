import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../app/controllers/auth_controller.dart';
import '../../../app/helpers/keys.dart';
import '../../../config/app_colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_app_button.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_textfield.dart';

class ResetPin extends StatefulWidget {
  const ResetPin({super.key});

  @override
  State<ResetPin> createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
  late AuthController authController;
  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    authController.pinController.value.addListener(() {
      authController.update();
    });

    authController.oldPinController.value.addListener(() {
      authController.update(); // Force update on text change
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reset Pin',
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To reset your Pin, Kindly provide your new Pin',
                style: t.bodyMedium,
              ),
              Gap(30),
              Text(
                "Old Pin",
                style: t.bodyMedium,
              ),
              Gap(10),
              Obx(
                () => CustomTextField(
                    maxLength: 4,
                    hintText: 'Enter Old Pin',
                    keyboardType: TextInputType.number,
                    controller: authController.oldPinController.value),
              ),
              Gap(20),
              Text(
                "New Pin",
                style: t.bodyMedium,
              ),
              Gap(10),
              Obx(() => CustomTextField(
                  maxLength: 4,
                  hintText: 'Enter New Pin',
                  keyboardType: TextInputType.number,
                  controller: authController.pinController.value)),
              Gap(140),
              Obx(
                () => Container(
                  color: Colors.transparent,
                  child: CustomAppButton(
                    isLoading: authController.isResetting.value,
                    text: "Reset Pin",
                    bgColor: authController.pinController.value.text.isEmpty ||
                            authController.oldPinController.value.text.isEmpty
                        ? Get.isDarkMode
                            ? AppColors.secondaryColor.withOpacity(0.3)
                            : AppColors.mainColor.withOpacity(0.3)
                        : Get.isDarkMode
                            ? AppColors.secondaryColor
                            : AppColors.mainColor,
                    textColor: Colors.white,
                    onTap: authController.pinController.value.text.isEmpty ||
                            authController.oldPinController.value.text.isEmpty
                        ? null
                        : () async {
                            final savedPin = HiveHelper.read(Keys.userPin);
                            if (authController.oldPinController.value.text !=
                                savedPin) {
                              return CustomDialog.showError(
                                  message: "Invalid Old Pin",
                                  buttonText: "close",
                                  context: context);
                            }
                            await authController.resetPin(
                                pin: authController.pinController.value.text,
                                Oldpin:
                                    authController.oldPinController.value.text);
                          },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/custom_textfield.dart';

class Resetpassword extends StatefulWidget {
  final String email;
  const Resetpassword({super.key, required this.email});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Image.asset(
              'assets/images/up_bg.png',
              width: MediaQuery.of(context).size.width * 2,
              height: 150.h,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.only(left: 14.0.w),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                  )),
            ),
            Container(
                padding: EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset Your Password ',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      Gap(30),
                      Text(
                        'Please enter your email address to receive a password reset link',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Gap(50),
                      Text(
                        'New Password',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      CustomTextField(
                        hintText: "Enter New Password",
                        controller: controller.passwordEditingController,
                        onChanged: (v) {
                          controller.passwordEditingVal.value = v;
                          controller.update();
                        },
                      ),
                      Gap(20),
                      Text(
                        'Confirm Password',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      CustomTextField(
                        hintText: "Confirm Password",
                        controller: controller.confirmPasswordEditingController,
                        onChanged: (v) {
                          controller.confirmPasswordEditingVal.value = v;
                          controller.update();
                        },
                      ),
                      Gap(50),
                      Obx(() => CustomAppButton(
                            isLoading: controller.isLoading.value,
                            bgColor: controller
                                        .passwordEditingVal.value.isEmpty ||
                                    controller
                                        .confirmPasswordEditingVal.value.isEmpty
                                ? Get.isDarkMode
                                    ? AppColors.secondaryColor.withOpacity(0.3)
                                    : AppColors.mainColor.withOpacity(0.3)
                                : Get.isDarkMode
                                    ? AppColors.secondaryColor
                                    : AppColors.mainColor,
                            onTap: controller
                                        .passwordEditingVal.value.isEmpty ||
                                    controller
                                        .confirmPasswordEditingVal.value.isEmpty
                                ? null
                                : () {
                                    if (controller.passwordEditingVal.value !=
                                        controller
                                            .confirmPasswordEditingVal.value) {
                                      CustomDialog.showError(
                                          context: context,
                                          message: "Passwords does not match",
                                          buttonText: 'close');
                                    } else {
                                      controller.resetPassword(widget.email,
                                          controller.passwordEditingVal.value);
                                    }
                                  },
                          ))
                    ]))
          ])),
    );
  }
}

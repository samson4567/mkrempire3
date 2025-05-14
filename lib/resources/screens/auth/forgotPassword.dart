import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/screens/auth/forgotCode.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/custom_textfield.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Center(
                child: Image.asset(
                  'assets/images/white_logo.png',
                  // width: MediaQuery.of(context).size.width * 2,
                  height: 250.h,
                  fit: BoxFit.fill,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 14.0.w),
              //   child: IconButton(
              //       onPressed: () {
              //         Get.back();
              //       },
              //       icon: Icon(
              //         Icons.arrow_back,
              //         size: 24.sp,
              //       )),
              // ),
              Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot Your Password ',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.start,
                        ),
                        Gap(30),
                        Text(
                          'Please enter your email address to receive a password reset link',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Gap(50),
                        CustomTextField(
                          hintText: "Enter Email Address",
                          controller:
                              controller.forgotPassEmailEditingController,
                          onChanged: (v) {
                            controller.forgotPassEmailVal.value = v;
                            if (!v.contains('@')) {
                              controller.forgotPassEmailVal.value = "";
                            }
                            controller.update();
                          },
                        ),
                        Gap(50),
                        Obx(() => CustomAppButton(
                            isLoading: controller.isLoading.value,
                            text: "Send OTP",
                            bgColor: controller.forgotPassEmailVal.value.isEmpty
                                ? Get.isDarkMode
                                    ? AppColors.secondaryColor.withOpacity(0.3)
                                    : AppColors.mainColor.withOpacity(0.3)
                                : Get.isDarkMode
                                    ? AppColors.secondaryColor
                                    : AppColors.mainColor,
                            onTap: () {
                              controller
                                  .forgotPassword(
                                      controller.forgotPassEmailVal.value)
                                  .then((_) {
                                controller.forgotPassEmailEditingController
                                    .clear();
                              });
                            }))
                      ]))
            ])),
      );
    });
  }
}

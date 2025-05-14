import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/profile_controller.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_textfield.dart';

class ChangePasswords extends StatelessWidget {
  const ChangePasswords({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<ProfileController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Change Password",
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(42.h),
                    Text("Current Password", style: t.displayMedium),
                    Gap(10.h),
                    Container(
                      height: 50.h,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppThemes.getSliderInactiveColor(),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 20.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.textFieldHintColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              fillColor: Colors.transparent,
                              // isBorderColor: false,
                              // height: 50.h,
                              // obsCureText:
                              //     controller.currentPassShow ? true : false,
                              hintText: "Enter Current Password",
                              controller:
                                  controller.currentPassEditingController,
                              onChanged: (v) {
                                controller.currentPassVal.value = v;
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.currentPassObscure();
                              },
                              icon: Icon(
                                controller.currentPassShow
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20.sp,
                              )),
                        ],
                      ),
                    ),
                    Gap(24.h),
                    Text("New Password", style: t.displayMedium),
                    Gap(10.h),
                    Container(
                      height: 50.h,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppThemes.getSliderInactiveColor(),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 20.h,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.textFieldHintColor,
                          ),
                          Expanded(
                            child: CustomTextField(
                              fillColor: Colors.transparent,
                              // isBorderColor: false,
                              // height: 50.h,
                              // obsCureText:
                              //     controller.isNewPassShow ? true : false,
                              hintText: "Enter New Password",
                              controller: controller.newPassEditingController,
                              onChanged: (v) {
                                controller.newPassVal.value = v;
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.newPassObscure();
                              },
                              icon: Icon(
                                controller.isNewPassShow
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20.sp,
                              )),
                        ],
                      ),
                    ),
                    Gap(24.h),
                    Text("Confirm Password", style: t.displayMedium),
                    Gap(10.h),
                    Container(
                        height: 50.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: AppThemes.getSliderInactiveColor(),
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 20.h,
                              color: Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.textFieldHintColor,
                            ),
                            Expanded(
                              child: CustomTextField(
                                // isBorderColor: false,
                                // height: 50.h,
                                // obsCureText:
                                //     controller.isConfirmPassShow ? true : false,
                                hintText: "Confirm Password",
                                controller: controller.confirmEditingController,
                                onChanged: (v) {
                                  controller.confirmPassVal.value = v;
                                },
                                fillColor: Colors.transparent,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  controller.confirmPassObscure();
                                },
                                icon: Icon(
                                  controller.isConfirmPassShow
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                )),
                          ],
                        )),
                    Gap(380),
                    Obx(
                      () => Container(
                        child: CustomAppButton(
                            bgColor: controller.confirmPassVal.value.isEmpty ||
                                    controller.newPassVal.value.isEmpty
                                ? Get.isDarkMode
                                    ? AppColors.secondaryColor.withOpacity(0.3)
                                    : AppColors.mainColor.withOpacity(0.3)
                                : Get.isDarkMode
                                    ? AppColors.secondaryColor
                                    : AppColors.mainColor,
                            text: "Update Password",
                            onTap: controller.confirmPassVal.value.isEmpty ||
                                    controller.newPassVal.value.isEmpty
                                ? null
                                : () {
                                    controller.updatePassword(
                                        newPass: controller.newPassVal.value);
                                  }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

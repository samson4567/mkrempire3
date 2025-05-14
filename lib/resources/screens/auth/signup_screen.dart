import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/config/app_contants.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_themes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
        body: SingleChildScrollView(
          // Make everything scrollable
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              Center(
                child: Image.asset(
                  'assets/images/white_logo.png',
                  // width: MediaQuery.of(context).size.width * 0.9,
                  height: 200.h,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text('Sign up to ${AppConstants.appName}'),
                    const SizedBox(height: 50),
                    // Replace fullName with firstName

                    Obx(() {
                      return CustomTextField(
                        controller: controller.fNameController.value,
                        hintText: 'First Name',
                        prefixIcon: const Icon(Icons.person),
                        onChanged: (val) => controller.update(),
                      );
                    }),
                    const SizedBox(height: 20),
                    // Add lastName field

                    Obx(() {
                      return CustomTextField(
                        controller: controller.lNameController.value,
                        hintText: 'Last Name',
                        prefixIcon: Icon(Icons.person),
                        onChanged: (val) => controller.update(),
                      );
                    }),
                    const SizedBox(height: 20),

                    Obx(() {
                      return CustomTextField(
                        controller: controller.emailController.value,
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.mail),
                        onChanged: (val) => controller.update(),
                      );
                    }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppThemes.getFillColor(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.r)),
                            border: Border.all(
                                color: AppThemes.borderColor(), width: 0.12),
                          ),
                          child: CountryCodePicker(
                            padding: EdgeInsets.zero,
                            dialogBackgroundColor: AppThemes.getDarkCardColor(),
                            dialogTextStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 16.sp),
                            flagWidth: 29.w,
                            textStyle:
                                Theme.of(context).textTheme.displayMedium,
                            onChanged: (CountryCode countryCode) {
                              controller.countryCode = countryCode.code!;
                              controller.phoneCode = countryCode.dialCode!;
                              controller.countryName = countryCode.name!;
                            },
                            initialSelection: 'NG',
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),
                        ),
                        Expanded(
                          child: Obx(() {
                            return CustomTextField(
                              controller: controller.phoneController.value,
                              hintText: 'Phone Number',
                              onChanged: (val) => controller.update(),
                              // onChanged: (val) {
                              //   controller.phoneController.value.text = val;
                              // },
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Obx(() {
                      return CustomTextField(
                        controller: controller.passwordController.value,
                        hintText: 'Password',
                        maxlines: 1,
                        obscureText: true,
                        prefixIcon: Icon(Icons.password),
                        onChanged: (val) => controller.update(),
                      );
                    }),
                    const SizedBox(height: 20),

                    Obx(() {
                      return CustomTextField(
                        controller: controller.confirmPasswordController.value,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        prefixIcon: Icon(Icons.password),
                        onChanged: (val) => controller.update(),
                      );
                    }),

                    const SizedBox(height: 30),
                    Obx(() {
                      return CustomAppButton(
                        isLoading: controller.isLoading.value,
                        bgColor: controller.isAnyFieldEmpty
                            ? Get.isDarkMode
                                ? AppColors.secondaryColor.withOpacity(0.3)
                                : AppColors.mainColor.withOpacity(0.3)
                            : Get.isDarkMode
                                ? AppColors.secondaryColor
                                : AppColors.mainColor,
                        onTap: controller.isAnyFieldEmpty
                            ? () {
                                print(controller.isAnyFieldEmpty);
                                print({
                                  controller.lNameController.value.text,
                                  controller.emailController.value.text,
                                  controller.passwordController.value.text,
                                  controller.fNameController.value.text
                                }); // Set to null when any field is empty
                              }
                            : () async {
                                print(controller.isAnyFieldEmpty);
                                controller.register(
                                  email: controller.emailController.value.text,
                                  password:
                                      controller.passwordController.value.text,
                                  fname: controller.fNameController.value.text,
                                  lname: controller.lNameController.value.text,
                                  phone: controller.phoneController.value.text,
                                  countryCode: controller.countryCode,
                                  countryName: controller.countryName,
                                  phoneCode: controller.phoneCode,
                                );
                              },
                        text: 'Sign Up',
                      );
                    }),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      InkWell(
                          onTap: () => Get.toNamed(RoutesName.loginScreen),
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.blue, // For a link-style text
                            ),
                          )),
                    ]),
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

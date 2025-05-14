import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/screens/auth/resetPassword.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../widgets/custom_app_button.dart';

class Forgotcode extends StatefulWidget {
  final String email;
  const Forgotcode({super.key, required this.email});

  @override
  State<Forgotcode> createState() => _ForgotcodeState();
}

class _ForgotcodeState extends State<Forgotcode> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController otpController = TextEditingController();

  int _secondsRemaining = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                  const Text(
                    'Verify your OTP 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter 5 digits code sent to your email address',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 50),
                  PinCodeTextField(
                    maxLength: 5,
                    pinBoxWidth: 50.w,
                    pinBoxHeight: 50.h,
                    defaultBorderColor: Get.isDarkMode
                        ? AppColors.black70
                        : AppColors.black20.withOpacity(0.3),
                    pinBoxColor: Get.isDarkMode
                        ? AppColors.black70
                        : AppColors.black20.withOpacity(0.3),
                    pinBoxRadius: 8,
                    controller: otpController,
                  ),
                  SizedBox(height: 30),
                  Obx(() => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60.h,
                        child: CustomAppButton(
                          isLoading: authController.isLoading.value,
                          onTap:
                              // () {
                              //   Get.to(() => Resetpassword(
                              //         email: widget.email,
                              //       ));
                              // },
                              () => authController.verifyForgotPasswordCode(
                                  widget.email, otpController.text),
                          text: 'Verify',
                        ),
                      )),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Resend OTP in ', style: TextStyle(fontSize: 16.sp)),
                      Text(
                        '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (_secondsRemaining == 0)
                    GestureDetector(
                      onTap: () => authController.forgotPassword(widget.email),
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

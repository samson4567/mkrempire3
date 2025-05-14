import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/repository/auth_repo.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';
import 'dart:async';

class EmailOtpScreen extends StatefulWidget {
  const EmailOtpScreen({super.key});

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final AuthController authController = Get.put(AuthController());
  final List<TextEditingController> _otpFieldsControllers =
      List.generate(6, (_) => TextEditingController());
  int _secondsRemaining = 30;
  late Timer _timer;
  late AuthRepo authRepo;

  @override
  void initState() {
    super.initState();
    _startTimer();
    authRepo = AuthRepo();
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

  void _verifyOtp() {
    // Combine the OTP from all fields
    String otp =
        _otpFieldsControllers.map((controller) => controller.text).join('');
    print('OTP: $otp');
    if (otp.length == 6) {
      // Proceed with OTP verification
      authController.verifyOtp(otp);
    } else {
      CustomDialog.showError(
          context: context,
          message: 'Please enter a valid 6-digit OTP.',
          buttonText: 'Back');
    }
  }

  void _resendOtp() async {
    setState(() {
      _secondsRemaining = 30;
    });
    _startTimer();
    var responses = await authRepo.dashboard();
    if (responses['message'] == 'Email Verification Required') {
      Get.toNamed(RoutesName.emailOtpScreen);
    } else {
      Get.offAllNamed(RoutesName.bottomNavBar);
    }
    print("Resending OTP...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackIcon: false,),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/white_logo.png',
              width: MediaQuery.of(context).size.width * 2,
              height: 150.h,
              fit: BoxFit.fill,
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
                    'Enter 6 digits code sent to your email address',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50.w,
                        child: CustomTextField(
                          fillColor: Get.isDarkMode
                              ? AppColors.black80
                              : AppColors.black20.withOpacity(0.3),
                          controller: _otpFieldsControllers[index],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.h,
                    child: CustomAppButton(
                      onTap: _verifyOtp,
                      text: 'Verify',
                    ),
                  ),
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
                      onTap: _resendOtp,
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

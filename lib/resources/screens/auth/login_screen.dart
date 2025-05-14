import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/resources/screens/auth/forgotPassword.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        body: SingleChildScrollView(
          // Make everything scrollable
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/white_logo.png',
                width: MediaQuery.of(context).size.width * 2,
                height: 400.h,
                fit: BoxFit.fill,
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    const Text('Login in to mkrempire'),
                    const SizedBox(height: 50),
                    CustomTextField(
                      controller: authController.emailEditingController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.alternate_email,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: authController.signInPassEditingController,
                      hintText: 'Password',
                      obscureText: true,
                      maxlines: 1,
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => Forgotpassword());
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Obx(() {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60.h,
                        child:
                            //  authController.isLoading.value ? Container(
                            //   child: CircularProgressIndicator(),
                            // ):
                            CustomAppButton(
                          onTap: () async {
                            HiveHelper.cleanall();
                            authController.singInPassVal =
                                authController.signInPassEditingController.text;
                            authController.singInEmailVal =
                                authController.emailEditingController.text;
                            await authController.login(context);
                          },
                          isLoading:
                              authController.isLoading.value ? true : false,
                          text: 'Login',
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      InkWell(
                          onTap: () => Get.toNamed(RoutesName.signUpScreen),
                          child: Text(
                            'Don\'t have an account? Sign Up',
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

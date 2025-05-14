import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/onboarding_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final onboardingController = Get.put(OnboardingController());
  final PageController _pageController =
      PageController(); // Add a PageController

  @override
  Widget build(BuildContext context) {
    HiveHelper.write(Keys.onBoarded, true);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller:
                    _pageController, // Use PageController to control the page view
                onPageChanged: (index) =>
                    onboardingController.currentPage.value = index,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: onboardingData[index]['title'],
                    description: onboardingData[index]['description'],
                    imagePath: onboardingData[index]['imagePath'],
                  );
                },
              ),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      height: 5.h,
                      width: onboardingController.currentPage.value == index
                          ? 20.w
                          : 10.w,
                      decoration: BoxDecoration(
                        color: onboardingController.currentPage.value == index
                            ? Colors.orange
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Back" or "Skip" Button
                  TextButton(
                    onPressed: () {
                      if (onboardingController.currentPage.value > 0) {
                        // Navigate to the previous page if not on the first page
                        onboardingController.currentPage.value--;
                        _pageController.animateToPage(
                          onboardingController.currentPage.value,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      } else {
                        // Skip if on the first page
                        onboardingController.skip();
                      }
                    },
                    child: Obx(() => Text(
                          onboardingController.currentPage.value > 0
                              ? "Back"
                              : "Skip",
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                        )),
                  ),
                  // "Next" or "Finish" Button
                  Obx(() => CustomAppButton(
                        onTap: () {
                          onboardingController.nextPage(onboardingData);
                          // Animate to the next page
                          _pageController.animateToPage(
                            onboardingController.currentPage.value,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        buttonWidth: 100.w,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
                        text: onboardingController.currentPage.value ==
                                onboardingData.length - 1
                            ? "Login"
                            : "Next",
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final dynamic title;
  final dynamic description;
  final dynamic imagePath;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            description,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// Mock onboarding data
final List<Map<String, String>> onboardingData = [
  {
    'title': 'Welcome to MKR Empire.',
    'description':
        'Effortlessly manage your bills, send money, create virtual cards, and explore gift cards—all in one place. Fast, secure, and designed just for you.',
    'imagePath': 'assets/images/onboarding1.png',
  },
  {
    'title': 'Fast, Secure, and Reliable.',
    'description':
        'Experience seamless transactions with top-notch security. Pay bills, transfer money, and shop online with confidence using MKR Empire.',
    'imagePath': 'assets/images/onboarding2.png',
  },
  {
    'title': 'Join the MKR Empire Community!',
    'description':
        " Unlock exclusive offers, earn rewards, and enjoy seamless transactions. Log in now and start your journey with MKR Empire!",
    'imagePath': 'assets/images/onboarding3.png',
  },
];

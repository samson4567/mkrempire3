import 'dart:async'; // Import for Timer

import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/navController.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/screens/billpayments/airtime_screen.dart';
import 'package:mkrempire/resources/screens/finance/transfer_to_mkrempire.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';

class CustomAdvertTextSlider extends StatefulWidget {
  const CustomAdvertTextSlider({super.key});

  @override
  _CustomAdvertTextSliderState createState() => _CustomAdvertTextSliderState();
}

class _CustomAdvertTextSliderState extends State<CustomAdvertTextSlider> {
  // List of images for the slider
  final List<Map> textAds = [
    {
      'title': 'Free Tranfer',
      'desc': 'Enjoy Free transfer from mkrempire to mkrempire',
      'ontap': () {
        Get.to(() => TransferTomkrempire());
        print('Airtime tapped');
      },
    },
    {
      'title': 'Virtual Card',
      'desc':
          'Shop securely online with your mkrempire Virtual Card. \nZero fees, instant activation.',
      'ontap': () {
        NavigationController navigationController = Get.find();
        navigationController.changeScreen(2);
        print('Virtual Card tapped');
      },
    },
    {
      'title': 'Gift Card',
      'desc': 'Buy your Gift Cards on mkrempire. \nFast and secure, purchase.',
      'ontap': () {
        NavigationController navigationController = Get.find();
        navigationController.changeScreen(1);
      },
    },

    // 'assets/images/onboarding1.png',
    // 'assets/images/onboarding2.png',
    // 'assets/images/onboarding3.png',
    // 'assets/images/onboarding1.png',
    // 'assets/images/onboarding2.png',
  ];

  // Controller for PageView
  final PageController _pageController = PageController();

  // Timer for auto sliding
  late Timer _timer;

  // Auto slide interval in seconds
  final int _slideInterval = 5;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  // Start the auto slide functionality
  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: _slideInterval), (timer) {
      if (_pageController.page?.toInt() == textAds.length - 1) {
        _pageController.jumpToPage(0); // Go back to first image
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ); // Go to the next image
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(bo8.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: textAds.length,
        itemBuilder: (context, index) {
          final ads = textAds[index];
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Get.isDarkMode
                    ? AppColors.secondaryColor.withOpacity(0.05)
                    : AppColors.mainColor.withOpacity(0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ads['title'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          ads['desc'],
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 11),
                        ),
                      ]),
                  InkWell(
                      onTap: ads['ontap'],
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        // margin: const EdgeInsets.only(bottom: 22),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text("View",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.whiteColor,
                            )),
                      ))
                ],
              ));
        },
      ),
    );
  }
}

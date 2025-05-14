import 'dart:async'; // Import for Timer

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class CustomAdvertSliders extends StatefulWidget {
  @override
  _CustomAdvertSlidersState createState() => _CustomAdvertSlidersState();
}

class _CustomAdvertSlidersState extends State<CustomAdvertSliders> {
  // List of images for the slider
  final AuthController controller = Get.put(AuthController());

  // Controller for PageView
  final PageController _pageController = PageController();

  // Timer for auto sliding
  late Timer _timer;

  // Auto slide interval in seconds
  final int _slideInterval = 3;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  // Start the auto slide functionality
  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: _slideInterval), (timer) {
      if (_pageController.page?.toInt() == controller.ads.length - 1) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: controller.ads.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(30.r),
            ),
            child: Image.network(
              // height: 100,

              controller.ads[index]['image_url'], // Image path from the list
              fit: BoxFit.fitWidth, // Fit the image within the container
            ),
          );
        },
      ),
    );
  }
}

class CustomAdvertSliders2 extends StatefulWidget {
  @override
  _CustomAdvertSliders2State createState() => _CustomAdvertSliders2State();
}

class _CustomAdvertSliders2State extends State<CustomAdvertSliders2> {
  // List of images for the slider
  final List<String> _imageUrls = [
    'assets/images/AdsImage3.jpg',
    'assets/images/AdsImage4.jpg',
    'assets/images/AdsImage5.jpg',
  ];

  // Controller for PageView
  final PageController _pageController = PageController();

  // Timer for auto sliding
  late Timer _timer;

  // Auto slide interval in seconds
  final int _slideInterval = 3;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  // Start the auto slide functionality
  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: _slideInterval), (timer) {
      if (_pageController.page?.toInt() == _imageUrls.length - 1) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(30.r),
            ),
            child: Image.asset(
              _imageUrls[index], // Image path from the list
              fit: BoxFit.fitHeight, // Fit the image within the container
            ),
          );
        },
      ),
    );
  }
}

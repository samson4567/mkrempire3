import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:get/get.dart';

class CustomVirtualCardDesign extends StatefulWidget {
  final int currentPage;
  final Function(int) onPageChanged; // Add callback function

  CustomVirtualCardDesign({
    super.key,
    required this.currentPage,
    required this.onPageChanged, // Make it required
  });

  @override
  _CustomVirtualCardDesignState createState() =>
      _CustomVirtualCardDesignState();
}

class _CustomVirtualCardDesignState extends State<CustomVirtualCardDesign> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: noCardImage.length,
            onPageChanged: (index) {
              // Call the parent's callback function
              widget.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              dynamic image = noCardImage[index]['image'];
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/white_logo.png',
                          // width: 120.w,
                          height: 70.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Virtual Card',
                          style: TextStyle(color: Colors.white),
                        ),
                        Image.asset(
                          'assets/images/$image.png',
                          width: 50.w,
                          height: 30.h,
                          color: image == 'visa' ? Colors.white : null,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(noCardImage.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.currentPage == index
                    ? Get.isDarkMode
                        ? AppColors.secondaryColor
                        : AppColors.mainColor
                    : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> noCardImage = [
    {
      'image': 'mastercard',
    },
    {
      'image': 'visa',
    }
  ];
}

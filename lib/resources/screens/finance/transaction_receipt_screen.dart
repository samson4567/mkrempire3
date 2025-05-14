import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionReceiptScreen extends StatefulWidget {
  const TransactionReceiptScreen({super.key});

  @override
  TransactionReceiptScreenState createState() =>
      TransactionReceiptScreenState();
}

class TransactionReceiptScreenState extends State<TransactionReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (appController) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Transaction Receipt',
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22),
          children: [
            // SizedBox(height: 30.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/white_logo2.png',
                  width: 150,
                  height: 100,
                  color: Get.isDarkMode
                      ? AppColors.secondaryColor
                      : AppColors.mainColor,
                ),
                Text(
                  'Transaction Receipt',
                  style: TextStyle(
                      // fontSize: 14
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Gap(20),
            Center(
              child: Text(
                '\$1000.00',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode
                      ? AppColors.secondaryColor
                      : AppColors.mainColor,
                ),
              ),
            ),
            Center(
              child: Text(
                'Successful',
                style:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
              ),
            ),
            Center(
              child: Text(
                'Feb 4th, 2025 23:09:42',
                style:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
              ),
            ),
            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recipient Details',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    'Chibuike nwachukwu'.toUpperCase(),
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),

            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recipient Details',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    'Darlington Etinosa Egharevba'.toUpperCase(),
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),

            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction Type',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                ),
                Text(
                  'mkrempire to mkrempire transfer',
                  style: TextStyle(
                    fontSize: 15.sp,
                    // fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),

            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction No',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                ),
                Text(
                  '3214124532543t51'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    // fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),

            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Session ID',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                ),
                Text(
                  'bfauhfudjkhafdsiuhladauifhvbfdluihruer',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.end,
                ),
              ],
            ),

            Gap(70.h),

            Center(
              child: Text('Support'),
            ),

            Center(
              child: Text(
                'customersupport@mkrempire.com.ng',
                style: TextStyle(
                  color: Get.isDarkMode
                      ? AppColors.secondaryColor
                      : AppColors.mainColor,
                ),
              ),
            ),
            Gap(30.h),

            Center(
              child: CustomAppButton(text: 'Share', textColor: Colors.white),
            ),
          ],
        ),
      );
    });
  }
}

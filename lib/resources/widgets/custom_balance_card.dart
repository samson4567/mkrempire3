import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:get/get.dart';

class CustomBalanceCard extends StatefulWidget {
  const CustomBalanceCard({super.key});

  @override
  State<CustomBalanceCard> createState() => _CustomBalanceCardState();
}

class _CustomBalanceCardState extends State<CustomBalanceCard> {
  AuthController balanceController = Get.put(AuthController());
  bool showBalance = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    balanceController.getBalance();
    showBalance = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 200.h,
        padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
        decoration: BoxDecoration(
          // boxShadow: Boxv
          color: Get.isDarkMode ? AppColors.mainColor : AppColors.mainColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.borderColor, width: 0.2),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Available balance',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            SizedBox(width: 12),
            InkWell(
              onTap: () {
                setState(() {
                  showBalance = !showBalance;
                });
                print(showBalance);
              },
              child: Icon(showBalance ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.whiteColor),
            )
          ]),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                showBalance
                    ? '₦${NumberFormat('#,##0.00').format(double.parse(balanceController.balance.value))}'
                    : "₦******",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              )),
              const SizedBox(width: 12),
              // Text('(Current balance)')
            ],
          )
        ]));
  }
}

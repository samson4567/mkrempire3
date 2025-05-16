import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_advert_text_slider.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/custom_advert_sliders.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
      appBar: const CustomAppBar(
        title: 'Deposit Money',
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        // physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 100,
            child: CustomAdvertTextSlider(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(16),
            // height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22)),
              color: AppColors.whiteColor.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'mkrempire Account Number',
                  style: TextStyle(fontSize: 14.sp),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "${HiveHelper.read(Keys.accountNumber)}",
                  style: TextStyle(fontSize: 34.sp),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '9 Payment Service Bank - ${HiveHelper.read(Keys.firstName)}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomAppButton(
                      text: 'Copy account number',
                      borderRadius: BorderRadius.all(Radius.circular(32.r)),
                      buttonWidth: 200.w,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: "${HiveHelper.read(Keys.accountNumber)}"));
                        CustomDialog.showSuccess(
                            context: context,
                            message: "Copied Successfully",
                            title: 'Success',
                            buttonText: 'close');
                      },
                    ),
                    CustomAppButton(
                      text: 'Share Details',
                      buttonWidth: 150.w,
                      borderRadius: BorderRadius.all(Radius.circular(32.r)),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                      onTap: () async {
                        final sharetext = '''
                    mkrempire Account Number
                    Account Number : ${HiveHelper.read(Keys.accountNumber)},
                    Bank Name: 9 Payment Service Bank ,
                    Full Name: ${HiveHelper.read(Keys.firstName)} 
''';
                        await Share.share(sharetext);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(16),
              // height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                color: AppColors.whiteColor.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  Text(
                    'This is a wallet used to warehouse cash for bill payments',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'interest, bonuses,payouts, from other banks and wallets & proceeds from investments are all paid into this wallet',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'You can transfer from your bank account to this wallet instantly with the account number above',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              )),
          50.verticalSpace,
          Container(
            height: 200.h,
            child: CustomAdvertSliders(),
          ),
        ],
      ),
    );
  }
}

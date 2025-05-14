import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/bill_payments_controller.dart';
import 'package:mkrempire/resources/widgets/custom_advert_sliders.dart';
import 'package:mkrempire/resources/widgets/custom_advert_text_slider.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../app/controllers/transferController.dart';
import '../../../config/app_colors.dart';
import 'transfer_to_other_banks/transferAmountScreen.dart';

class TransferTomkrempire extends StatefulWidget {
  const TransferTomkrempire({super.key});

  @override
  State<TransferTomkrempire> createState() => _TransferTomkrempireState();
}

class _TransferTomkrempireState extends State<TransferTomkrempire> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final Transfercontroller transferController = Get.put(Transfercontroller());
  var accountName = ''.obs;
  var accountNumber = ''.obs;
  final RxBool isNameFetched = false.obs;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    ever(transferController.accountName, (accountName) {
      nameController.text = accountName;
      isNameFetched.value = accountName.isNotEmpty;
    });

    accountController.addListener(() {
      accountNumber.value = accountController.text;
      if (accountNumber.value.length < 10) {
        transferController.accountName.value = '';
        return;
      }

      transferController.accountLookup(
          acctNo: accountNumber.value,
          // bank: '044'
          bank: '120001'); // Pass bank CODE, not name
    });
    nameController.addListener(() {
      accountName.value = nameController.text;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: 'Transfer to mkrempire',
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Transfers from your mkrempire account to other mkrempire accounts.',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    30.verticalSpace,
                    Container(
                        width: double.infinity,
                        height: 100,
                        child: CustomAdvertTextSlider()),
                    30.verticalSpace,
                    Obx(
                      () => Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0.sp),
                        height: isNameFetched.value == true ? 0.28.sh : 0.2.sh,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Get.isDarkMode
                              ? AppColors.black70.withOpacity(0.3)
                              : AppColors.mainColor.withOpacity(0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recipient Account",
                              style: t.bodyLarge,
                            ),
                            Gap(20),
                            CustomTextField(
                              hintText: 'Enter 10 digits Account Number',
                              keyboardType: TextInputType.number,
                              controller: accountController,
                            ),
                            Gap(10),
                            Obx(
                              () => transferController.isLooking.value == true
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 12.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Loading...',
                                            style: t.bodySmall,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                            height: 10.h,
                                            child: CircularProgressIndicator(
                                              color: Get.isDarkMode
                                                  ? AppColors.secondaryColor
                                                  : AppColors.mainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : isNameFetched == true
                                      ? GestureDetector(
                                          onTap: () {
                                            // Navigate to the next page with animation
                                            _pageController.animateToPage(
                                              1,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              border: Border.all(
                                                color: Get.isDarkMode
                                                    ? AppColors.secondaryColor
                                                        .withOpacity(0.3)
                                                    : AppColors.mainColor
                                                        .withOpacity(0.5),
                                                width: 0,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  transferController
                                                      .accountName.value
                                                      .toUpperCase(),
                                                  style: t.bodyMedium!.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors
                                                            .secondaryColor
                                                        : AppColors.mainColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                10.verticalSpace,
                                                Text(
                                                  accountNumber.value,
                                                  style: t.bodyMedium!.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors
                                                            .secondaryColor
                                                        : AppColors.mainColor,
                                                  ),
                                                ),
                                                10.verticalSpace,
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    50.verticalSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: Image.asset(
                        "assets/images/AdsImage.jpg",
                        width: 390.w,
                        height: 200.h,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  ],
                ),
              );
            } else {
              // Second page - Transfer amount screen
              return TransferAmountScreen(
                accountName: transferController.accountName.value,
                accountNumber: accountNumber.value,
                bankName: '',
                bankCode: '120001',
                onBack: () {
                  // Navigate back to first page
                  _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                ismkrempireAccount: true,
              );
            }
          },
        ),
      ),
    );
  }
}

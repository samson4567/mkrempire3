import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkrempire/app/controllers/kyc_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_bottomsheet.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:pinput/pinput.dart';

import '../../../app/helpers/hive_helper.dart';
import '../../../app/helpers/keys.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final KycController controller = Get.put(KycController());
  @override
  Widget build(BuildContext context) {
    print(HiveHelper.read(Keys.tier));
    return Scaffold(
      appBar: CustomAppBar(
        title: 'KYC Verification',
      ),
      body: HiveHelper.read(Keys.tier) == '2' ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/kyc.svg', height: 100, width: 100,color: AppColors.greenColor,),
                Text('Kyc Verified', style: TextStyle(
                  fontSize: 28,
                ),),
              ])
      ): SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
        child: Column(
          children: [
            Text(
              'Kindly provide your Bank Verification Number (BVN) to complete your KYC verification.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Gap(50),
            Obx(
              () => CustomTextField(
                hintText: 'Enter your BVN',
                controller: controller.bvnController.value,
              ),
            ),
            Gap(80),
            Obx(() => Container(
                  child: CustomAppButton(
                      isLoading: controller.isSubmitting.value == true,
                      bgColor: controller.isBvnEmpty.value
                          ? Get.isDarkMode
                              ? AppColors.secondaryColor.withOpacity(0.3)
                              : AppColors.mainColor.withOpacity(0.3)
                          : Get.isDarkMode
                              ? AppColors.secondaryColor
                              : AppColors.mainColor,
                      textColor: Colors.white,
                      onTap: controller.isBvnEmpty.value
                          ? null
                          : () {
                              controller.submitKyc(
                                  kycData: controller.bvnController.value.text,
                                  onPressed: () async {
                                    Get.back();
                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                              width: double.infinity,
                                              height: 0.5.sh,
                                              child: Padding(
                                                padding: EdgeInsets.all(18.0),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Confirm your Details',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                      Gap(20),
                                                      Container(
                                                          width: double
                                                              .infinity,
                                                          height: 0.05.sh,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0.w,
                                                                  vertical:
                                                                      8.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .black70
                                                                    .withAlpha(
                                                                        100)
                                                                : AppColors
                                                                    .bgColor
                                                                    .withAlpha(
                                                                        100),
                                                          ),
                                                          child: Text(
                                                              controller
                                                                  .firstName
                                                                  .value,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium)),
                                                      Gap(10),
                                                      Container(
                                                          width: double
                                                              .infinity,
                                                          height: 0.05.sh,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0.w,
                                                                  vertical:
                                                                      8.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .black70
                                                                    .withAlpha(
                                                                        100)
                                                                : AppColors
                                                                    .bgColor
                                                                    .withAlpha(
                                                                        100),
                                                          ),
                                                          child: Text(
                                                              controller
                                                                  .lastName
                                                                  .value,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium)),
                                                      Gap(10),
                                                      Container(
                                                          width: double
                                                              .infinity,
                                                          height: 0.05.sh,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0.w,
                                                                  vertical:
                                                                      8.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .black70
                                                                    .withAlpha(
                                                                        100)
                                                                : AppColors
                                                                    .bgColor
                                                                    .withAlpha(
                                                                        100),
                                                          ),
                                                          child: Text(
                                                              controller
                                                                  .phoneNumber
                                                                  .value,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium)),
                                                      Gap(10),
                                                      Container(
                                                          width: double
                                                              .infinity,
                                                          height: 0.05.sh,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0.w,
                                                                  vertical:
                                                                      8.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .black70
                                                                    .withAlpha(
                                                                        100)
                                                                : AppColors
                                                                    .bgColor
                                                                    .withAlpha(
                                                                        100),
                                                          ),
                                                          child: Text(
                                                              controller
                                                                  .dob.value,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium)),
                                                      Gap(50),
                                                      Container(
                                                        child: CustomAppButton(
                                                          bgColor: Get
                                                                  .isDarkMode
                                                              ? AppColors
                                                                  .secondaryColor
                                                              : AppColors
                                                                  .mainColor,
                                                          onTap: () {
                                                            controller
                                                                .sendOtp(() {
                                                              Get.back();
                                                              Get.back();
                                                              CustomBottomsheet.showWidget(
                                                                  context: context,
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    width: MediaQuery.of(context).size.width,
                                                                  padding: EdgeInsets.only(top: 12),
                                                                    // 15660
                                                              child: Column(
                                                              children: [
                                                                Gap(20),
                                                            Pinput(
                                                              length: 5,
                                                                onChanged:(String otp) async {
                                                                  if(otp.length == 5){
                                                                    controller.oTp.value = otp;
                                                                    await controller.verifyOtp(
                                                                        otpCode: controller.oTp.value, pinId: controller.pin_Id.value,
                                                                        dob:controller.dob.value,
                                                                        customerId:HiveHelper.read(Keys.payscribeId),
                                                                         identificationNumber:controller.bvnController.value.text
                                                                    );
                                                                  }
                                                                          // controller.oTp.value = otp;
                                                                          // await controller.verifyOtp(otpCode: controller.oTp.value, pinId: controller.pin_Id.value);
                                                                          // await _nextStep;
                                                                        },
                                                                      )
                                                              ],
                                                              )
                                                              ));
                                                              // showDialog(
                                                              //     context:
                                                              //         context,
                                                              //     builder:
                                                              //         (context) {
                                                              //        ;
                                                              //       // return AlertDialog(
                                                              //       //   contentPadding:
                                                              //       //       EdgeInsets.all(
                                                              //       //           32.sp),
                                                              //       //   content:
                                                              //       //       ,
                                                              //       // );
                                                              //     });
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ]),
                                              ));
                                        });
                                  });
                            }),
                ))
          ],
        ),
      )),
    );
  }
}

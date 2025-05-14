import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/referralControllers.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/helpers/keys.dart';
import '../../widgets/custom_dialog.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final ReferralControllers referralControllers =
      Get.put(ReferralControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Referral',
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Obx(
          () => referralControllers.isFetching.value == true
              ? CustomLoading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite friends to MKR Empire to earn Rewards ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 24,
                          color: Get.isDarkMode
                              ? AppColors.secondaryColor
                              : AppColors.mainColor),
                      textAlign: TextAlign.center,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(18.r)),
                        child: Image.asset(
                          'assets/images/earnreward.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 10.verticalSpace,
                    Center(
                      child: CustomAppButton(
                        buttonWidth: 0.5.sw,
                        borderRadius: BorderRadius.all(Radius.circular(18.r)),
                        text: 'Earn ₦${referralControllers.reward.value}',
                        onTap: () async {
                          final sharetext = '''
                     Use mkrempire for free transfers and earn rewards. Join me on mkrempire and earn.
                    Use my referral Link: ${referralControllers.link.value}
''';
                          await Share.share(sharetext);
                        },
                      ),
                    ),
                    20.verticalSpace,
                    Center(
                      child: Text(
                        'Share Invitation Code',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            readOnly: true,
                            enabled: true,
                            maxlines: 1,
                            controller: TextEditingController(
                                text: referralControllers.link.value),
                          ),
                        ),
                        20.horizontalSpace,
                        CustomAppButton(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: referralControllers.link.value));
                              CustomDialog.showSuccess(
                                  context: context,
                                  message: "Copied Successfully",
                                  title: 'Success',
                                  buttonText: 'close');
                            },
                            buttonWidth: 0.2.sw,
                            borderRadius:
                                BorderRadius.all(Radius.circular(18.r)),
                            text: 'Copy')
                      ],
                    ),
                    40.verticalSpace,
                    Text(
                      'Referrals',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    10.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.black80.withOpacity(0.6)
                              : AppColors.mainColor.withOpacity(0.03),
                          borderRadius:
                              BorderRadius.all(Radius.circular(18.r))),
                      child: referralControllers.referrals.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  25.verticalSpace,
                                  Image.asset(
                                    'assets/images/friend.png',
                                    width: 100.w,
                                    height: 100.w,
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    'No friends invited',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 18.sp),
                                  ),
                                  30.verticalSpace
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: referralControllers.referrals.length,
                              itemBuilder: (context, index) {
                                final referrals =
                                    referralControllers.referrals[index];
                                return ListTile(
                                  title: Text(referrals['name'] ?? 'Unknown'),
                                  subtitle: Text(
                                      'Reward: ${referrals['reward'] ?? 0}'),
                                  trailing: Text(referrals['date'] ?? 'N/A'),
                                );
                              }),
                    ),
                    40.verticalSpace,
                  ],
                ),
        ),
      )),
    );
  }
}

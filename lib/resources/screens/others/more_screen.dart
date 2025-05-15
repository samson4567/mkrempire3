import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/navController.dart';
import 'package:mkrempire/app/controllers/theme_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/config/app_contants.dart';
import 'package:mkrempire/resources/screens/others/change_passwords.dart';
import 'package:mkrempire/resources/screens/others/edit_profile.dart';
import 'package:mkrempire/resources/screens/others/kyc.dart';
import 'package:mkrempire/resources/screens/others/referralScreen.dart';
import 'package:mkrempire/resources/screens/others/resetPin.dart';
import 'package:mkrempire/resources/screens/others/supportsScreen.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/routes/route_names.dart';

import '../../../app/controllers/profile_controller.dart';
import '../../../config/app_themes.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isDarkMode = false;
  final bool _isBiometricEnabled = false;
  final ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appController) {
      return Scaffold(
        appBar: const CustomAppBar(
          isHomeScreen: false,
          title: 'More',
          showBackIcon: false,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return GetBuilder<ProfileController>(
                                        builder: (profileController) {
                                      return SizedBox(
                                        height: 0.2.sh,
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            20.verticalSpace,
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Get.isDarkMode
                                                    ? AppColors.secondaryColor
                                                    : AppColors.mainColor,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(height: 10.h),
                                                GestureDetector(
                                                  onTap: () async {
                                                    Get.back();
                                                    profileController.pickImage(
                                                        ImageSource.camera);
                                                  },
                                                  child: Container(
                                                    height: 80.h,
                                                    width: 150.w,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: AppThemes
                                                            .getDarkBgColor(),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: .2)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.camera_alt,
                                                          size: 35.h,
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .black50,
                                                        ),
                                                        Text(
                                                          'Pick from Camera',
                                                          style: t.bodySmall
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getIconBlackColor()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50.w,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    Get.back();
                                                    profileController.pickImage(
                                                        ImageSource.gallery);
                                                  },
                                                  child: Container(
                                                    height: 80.h,
                                                    width: 150.w,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: AppThemes
                                                            .getDarkBgColor(),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: .2)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.camera,
                                                          size: 35.h,
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .black50,
                                                        ),
                                                        Text(
                                                          'Pick from Gallery',
                                                          style: t.bodySmall
                                                              ?.copyWith(
                                                                  color: AppThemes
                                                                      .getIconBlackColor()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                              child: Obx(
                                () =>
                                    profileController.isUploadingPhoto.value ==
                                            true
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.whiteColor,
                                            ),
                                          )
                                        : ClipOval(
                                            child: profileController.uploadImage
                                                    .value.isNotEmpty
                                                ? Image.file(
                                                    File(
                                                      profileController
                                                          .uploadImage.value,
                                                    ),
                                                    height: 40.h,
                                                    width: 40.h,
                                                    fit: BoxFit.fill,
                                                  )
                                                : profileController.profileImage
                                                        .value.isEmpty
                                                    ? Image.asset(
                                                        'assets/images/onboarding1.png',
                                                        width: 30.w,
                                                        height: 30.h,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.network(
                                                        profileController
                                                            .profileImage.value,
                                                        height: 40.h,
                                                        width: 40.h,
                                                        fit: BoxFit.fill,
                                                        // fit: BoxFit.cover,
                                                      )),
                              )),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${HiveHelper.read(Keys.firstName)} ${HiveHelper.read(Keys.lastName)}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                HiveHelper.read(Keys.accountNumber),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      // height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor.withOpacity(0.1)
                            : AppColors.darkBgColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildShortcuts(),
                    ),

                    const SizedBox(height: 20),
                    Container(
                        // height: 300,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.whiteColor.withOpacity(0.1)
                              : AppColors.darkBgColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
// Settings List
                            // _buildSettingsItem(
                            //   icon: Icons.account_circle,
                            //   title: 'Accounts',
                            //   subtitle: 'Manage your accounts',
                            //   onTap: () {},
                            // ),

                            // _buildToggleSetting(
                            //   icon: Icons.fingerprint,
                            //   title: 'Biometric login',
                            //   value: _isBiometricEnabled,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       _isBiometricEnabled = value;
                            //     });
                            //   },
                            // ),
                            _buildToggleSetting(
                              icon: Icons.light_mode,
                              title: 'Switch between light & dark mode',
                              value:
                                  Get.find<ThemeController>().isDarkMode.value,
                              onChanged: (value) {
                                Get.find<ThemeController>().toggleTheme(value);
                                appController.selectedIndex = value ? 1 : 2;
                                appController.onChanged(value);

                                setState(() {
                                  _isDarkMode = value;
                                  Get.changeThemeMode(_isDarkMode
                                      ? ThemeMode.dark
                                      : ThemeMode.light);
                                });

                                if (Get.isRegistered<NavigationController>()) {
                                  Get.find<NavigationController>().update();
                                }

                                appController.update();
                              },
                            ),
                            _buildSettingsItem(
                                icon: Icons.logout,
                                title: 'Logout',
                                subtitle:
                                    'Logout from ${AppConstants.appName} account',
                                onTap: () => buildLogoutDialog(
                                      context,
                                      Theme.of(context).textTheme,
                                    )),
                          ],
                        )),

                    const SizedBox(height: 40),

                    // App Version
                    Center(
                      child: Text(
                        AppConstants.appName,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildQuickAction(
      {required String icon, required String label, required Color color}) {
    return Column(
      children: [
        CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.mainColor.withOpacity(0.05),
            child: SvgPicture.asset(
              "assets/svgs/$icon.svg",
              height: 22,
              width: 25,
              color: color,
            ) //Icon(icon, color: Colors.white, size: 30),
            ),
        // const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.red[800],
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 42),
    );
  }

  Widget _buildToggleSetting({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[800],
        child: Icon(icon, color: Colors.orange),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.orange,
      ),
    );
  }

  Future<dynamic> buildLogoutDialog(
    BuildContext context,
    TextTheme t,
  ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Log Out",
            style: t.bodyLarge?.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            "Do you want to Log Out?",
            style: t.bodyMedium?.copyWith(
                color: Get.isDarkMode == true ? Colors.white : Colors.black),
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Get.isDarkMode == true ? Colors.white : Colors.black,
                  ),
                  // style: t.bodyLarge,
                )),
            MaterialButton(
                onPressed: () async {
                  HiveHelper.remove(Keys.token);
                  HiveHelper.cleanall();
                  Get.offAllNamed(RoutesName.loginScreen);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Get.isDarkMode == true ? Colors.white : Colors.black,
                  ),
                  // style: t.bodyLarge,
                )),
          ],
        );
      },
    );
  }

  Widget _buildShortcuts() {
    return GridView.builder(
      shrinkWrap: true, // Ensures it doesn't take infinite height inside Column
      physics:
          const NeverScrollableScrollPhysics(), // Disables GridView scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust columns as needed
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 1.3,
      ),
      itemCount: firstDashboardShortCutData.length,
      itemBuilder: (context, index) {
        final item = firstDashboardShortCutData[index];
        print(item);
        return GestureDetector(
          onTap: item['ontap'] as VoidCallback?, // Cast ontap as function
          child: _buildQuickAction(
              icon: item['svg'], label: item['title']!, color: item['color']),
          // child: Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     // color: AppColors.mainColor.withOpacity(0.08),
          //     // border: Border.all(color: AppColors.mainColor)
          //   ),
          //   // padding: const EdgeInsets.all(5),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SvgPicture.asset(
          //         "assets/svgs/${item['svg']}.svg",
          //         height: 30,
          //         width: 30,
          //         color: item['color'],
          //       ),
          //       // Icon(Icons.dashboard, size: 40, color: Colors.blue), // Replace with SVG if needed
          //       const SizedBox(height: 8),
          //       Text(
          //         item['title']!,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //           color: Get.isDarkMode
          //               ? AppColors.whiteColor
          //               : AppColors.mainColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        );
      },
    );
  }

  /// Updated Dashboard Data Structure
  final List<Map<String, dynamic>> firstDashboardShortCutData = [
    {
      'title': 'Edit Profile',
      'svg': 'edit',
      'color': const Color(0xff12B600),
      'ontap': () {
        Get.to(() => const EditProfile());
      },
    },
    // {
    //   'title': 'Notifications',
    //   'svg': 'no_notification',
    //   'color': Color(0xffF45521),
    //   'ontap': () {
    //     print('Mobile Data tapped');
    //   },
    // },
    // {
    //   'title': 'Transactions',
    //   'svg': 'transaction',
    //   'color': Color(0xFFFF00FF),
    //   'ontap': () {
    //     NavigationController navigationController = Get.find();
    //     navigationController.changeScreen(3);
    //   },
    // },
    {
      'title': 'KYC',
      'svg': 'kyc',
      'color': const Color(0xFFFF00FF),
      'ontap': () {
        Get.to(() => const KYCScreen());
      },
    },
    {
      'title': 'Support',
      'svg': 'support',
      'color': const Color(0xffFF8900),
      'ontap': () {
        Get.to(() => const SupportsScreen());
      },
    },
    {
      'title': 'Referral',
      'svg': 'referral',
      'color': const Color(0xffF45521),
      'ontap': () {
        Get.to(() => const ReferralScreen());
      },
    },
    {
      'title': 'Password',
      'svg': 'password',
      'color': const Color(0xffFF8900),
      'ontap': () {
        Get.to(() => const ChangePasswords());
      },
    },
    {
      'title': 'Pin',
      'svg': 'pin',
      'color': const Color(0xffF45521),
      'ontap': () {
        Get.to(() => const ResetPin());
      },
    },
  ];
}

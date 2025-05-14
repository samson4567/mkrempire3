import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/navController.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:get/get.dart';

import '../../app/controllers/profile_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomeScreen;
  final bool showBackIcon;
  const CustomAppBar(
      {Key? key,
      this.title = '',
      this.isHomeScreen = false,
      this.showBackIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isHomeScreen
        ? AppBar(
            leading: showBackIcon
                ? InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new),
                  )
                : Container(),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(
                horizontal:
                    16), // Optional: Adds padding around the child widget
            child: Column(
              children: [
                SizedBox(
                  height: 70.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // ClipOval(
                        //     child: Image.asset(
                        //   'assets/images/onboarding1.png',
                        //   width: 40.w,
                        //   height: 30.h,
                        // )),
                        // Obx(
                        //   () =>
                        GestureDetector(
                            onTap: () {
                              NavigationController navigationController =
                                  Get.find<NavigationController>();
                              navigationController.changeScreen(4);
                            },
                            child: //HiveHelper.read(Keys.profilePic) != null ?
                            //  ClipOval(
                            //   child: Image.network(
                            //     "${HiveHelper.read(Keys.profilePic)}",
                            //     width: 30.w,
                            //     height: 30.h,
                            //     fit: BoxFit.fill,
                            //   ),
                            // )
                                ClipOval(
                              child: Image.asset(
                                'assets/images/onboarding1.png',
                                width: 30.w,
                                height: 30.h,
                                fit: BoxFit.fill,
                              ),
                            )
                            // child: Get.find<ProfileController>()
                            //         .uploadImage
                            //         .value
                            //         .isNotEmpty
                            //     ? Image.file(
                            //         File(
                            //           Get.find<ProfileController>()
                            //               .uploadImage
                            //               .value,
                            //         ),
                            //         height: 30.h,
                            //         width: 30.h,
                            //         fit: BoxFit.fill,
                            //       )
                            //     : Get.find<ProfileController>()
                            //             .profileImage
                            //             .value
                            //             .isEmpty
                            //         ? Image.asset(
                            //             'assets/images/onboarding1.png',
                            //             width: 30.w,
                            //             height: 30.h,
                            //             fit: BoxFit.fill,
                            //           )
                            //         : Image.network(
                            //             Get.find<ProfileController>()
                            //                 .profileImage
                            //                 .value,
                            //             height: 30.h,
                            //             width: 30.h, fit: BoxFit.fill,
                            //             // fit: BoxFit.cover,
                            //           )),
                            ),
                        // ),
                        SizedBox(
                          width: 10,
                        ), // Optional: Adds space between logo and title
                        Text(
                          "Hi ${HiveHelper.read(Keys.lastName)}👋",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black70,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        child: InkWell(
                      onTap: () {
                        // Implement your action when the icon is tapped
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100, 80, 0, 0),
                          items: [
                            PopupMenuItem(
                              child: Text("No new notifications"),
                            ),
                          ],
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svgs/no_notification.svg',
                        height: 20,
                        width: 20,
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.blackColor,
                      ),
                    ))
                  ],
                )
              ],
            ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/virtualCard_controller.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/app_colors.dart';
import '../../widgets/custom_app_button.dart';
import '../../widgets/custom_dialog.dart';

class VirtualcardslistScreen extends StatefulWidget {
  const VirtualcardslistScreen({super.key});

  @override
  State<VirtualcardslistScreen> createState() => _VirtualcardslistScreenState();
}

class _VirtualcardslistScreenState extends State<VirtualcardslistScreen> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<VirtualcardController>(builder: (virtualCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'My Virtual Cards',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                SizedBox(
                    height: 200,
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: virtualCtrl.virtualCardList.length,
                        itemBuilder: (context, index) {
                          dynamic image = noCardImage[index]['image'];
                          final card = virtualCtrl.virtualCardList[index];
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          'assets/images/white_logo2.png',
                                          width: 120.w,
                                          height: 50.h,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Card Name :',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          '${card['name']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Card Number :',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          '${card['masked']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Exp. Date :',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                        20.horizontalSpace,
                                        Text(
                                          '${card['expiry']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${card['card_type']}'.toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Image.asset(
                                          'assets/images/$image.png',
                                          width: 50.w,
                                          height: 30.h,
                                          color: image == 'visa'
                                              ? Colors.white
                                              : null,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SmoothPageIndicator(
                                controller: pageController,
                                count: virtualCtrl.virtualCardList.length,
                                effect: WormEffect(
                                    dotHeight: 3.h,
                                    dotWidth: 16.w,
                                    dotColor: Get.isDarkMode
                                        ? AppColors.secondaryColor
                                        : AppColors.mainColor),
                              ),
                              80.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          TopupMethod(context, t, virtualCtrl);
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          size: 30.sp,
                                        ),
                                      ),
                                      Text(
                                        'Top Up',
                                        style: t.bodyMedium,
                                      )
                                    ],
                                  ),
                                  20.horizontalSpace,
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          // _.showCardDetails();
                                          // await showModalBottomSheet(
                                          //     context: context,
                                          //     isScrollControlled: true,
                                          //     builder: (context) => Container(
                                          //           width: double.infinity,
                                          //           height: 0.5.sh,
                                          //           child: Column(
                                          //             children: [],
                                          //           ),
                                          //         ));
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 30.sp,
                                        ),
                                      ),
                                      Text(
                                        'Show Details',
                                        style: t.bodyMedium,
                                      )
                                    ],
                                  ),
                                  20.horizontalSpace,
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            moreOption(context, t, virtualCtrl),
                                        icon: Icon(
                                          Icons.more_horiz,
                                          size: 30.sp,
                                        ),
                                      ),
                                      Text(
                                        'More',
                                        style: t.bodyMedium,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          );
                        }))
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<dynamic> moreOption(
      BuildContext context, TextTheme t, VirtualcardController _) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            height: 0.8.sh,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 20.w, right: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 30.sp,
                          )),
                      60.horizontalSpace,
                      Text(
                        "USD card settings",
                        style: t.bodyLarge,
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () {
                      _.terminateCard();
                    },
                    title: Text(
                      'Delete Card',
                      style: t.bodyMedium,
                    ),
                    subtitle: Text(
                      'Delete your card and return funds to your wallet',
                      style: t.bodySmall,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _.freezeCard();
                    },
                    title: Text(
                      'Freeze Card',
                      style: t.bodyMedium,
                    ),
                    subtitle: Text(
                      'Freezing your card will result in all attempted transaction being declined.',
                      style: t.bodySmall,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _.unfreezeCard();
                    },
                    title: Text(
                      'Unfreeze Card',
                      style: t.bodyMedium,
                    ),
                    subtitle: Text(
                      'Unfreezing your card will result in resuming all card activities',
                      style: t.bodySmall,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> TopupMethod(
      BuildContext context, TextTheme t, VirtualcardController _) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 20.w, right: 20.w),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 30.sp,
                              )),
                        ],
                      ),
                      60.horizontalSpace,
                      Text(
                        "Top Up",
                        style: t.bodyLarge,
                      ),
                      Gap(20),
                      CustomTextField(
                        hintText: 'Enter Amount',
                        controller: _.amountController,
                      ),
                      Gap(50),
                      CustomAppButton(
                        textColor: Colors.white,
                        onTap: () async {
                          if (_.amountController.text.isEmpty) {
                            return CustomDialog.showWarning(
                                context: Get.context!,
                                buttonText: "close",
                                message: "Please Kindly fill the field");
                          }
                          final amount = double.parse(_.amountController.text);
                          await _.TopUp(
                            amount: amount,
                          );
                        },
                      ),
                      Gap(30),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      )
                    ]),
              ),
            ),
          );
        });
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

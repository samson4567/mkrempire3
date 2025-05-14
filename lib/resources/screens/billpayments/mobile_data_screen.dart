import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/bill_payments_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../app/controllers/app_controller.dart';

class MobileDataScreen extends StatefulWidget {
  const MobileDataScreen({super.key});

  @override
  State<MobileDataScreen> createState() => _MobileDataScreenState();
}

class _MobileDataScreenState extends State<MobileDataScreen> {
  final BillPaymentsController controller = Get.put(BillPaymentsController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _init();
    });
  }

  Future<void> _init() async {
    await controller.dataLookUp(network: 'mtn');
    await controller.fetchOtherServices(service: 'airtime');
  }

  void _showNetworkBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) {
            return GetBuilder<BillPaymentsController>(
              builder: (_) {
                return controller.isLoading.value
                    ? CustomLoading()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.services.length,
                        itemBuilder: (context, index) {
                          final services = controller.services[index];
                          return InkWell(
                            onTap: () async {
                              final selectedNetwork = services.title
                                  .replaceAll(' Airtime', '')
                                  .toUpperCase();

                              // Close bottom sheet before updating state
                              Get.back();

                              // Update state safely after closing the sheet
                              controller.selectedNetwork.value =
                                  selectedNetwork;
                              await controller.dataLookUp(
                                  network: selectedNetwork.toLowerCase());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      services.logoUrl,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    services.title
                                        .replaceAll('Airtime', 'Network'),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const Gap(20),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Mobile Data'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(height: 20.h),
            const Text('Select Network'),
            SizedBox(height: 10.h),
            InkWell(
              onTap: _showNetworkBottomSheet,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withAlpha(32),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return Row(
                        children: [
                          ClipOval(
                            child: SvgPicture.asset(
                              'assets/svgs/${controller.selectedNetwork.value.toLowerCase()}.svg',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Gap(10),
                          Text(controller.selectedNetwork.value),
                        ],
                      );
                    }),
                    const Icon(Icons.arrow_drop_down_circle),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            const Text('Phone number'),
            SizedBox(height: 20.h),
            CustomTextField(
              hintText: "Enter your Phone number",
              controller: controller.phoneController,
            ),
            SizedBox(height: 30.h),
            Obx(() {
              return controller.isLoading.value
                  ? CustomLoading()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: controller.plans.length,
                      itemBuilder: (context, index) {
                        final plan = controller.plans[index];
                        final nameList = plan.name.split('-');
                        final nameList2 = nameList[0].split('+');
                        final gb = nameList2[0].split(' ');

                        return InkWell(
                          onTap: () async {
                            final AuthController authController = Get.find();
                            if (controller.phoneController.text.isEmpty) {
                              CustomDialog.showWarning(
                                context: context,
                                message: 'Please Enter Phone Number',
                                buttonText: 'Close',
                              );
                              return;
                            } else {
                              // if (!authController
                              //     .canProcessTransaction(plan.amount)) {
                              //   CustomDialog.showWarning(
                              //       context: context,
                              //       message:
                              //           'Insufficient Balance for this transaction',
                              //       buttonText: 'Close');
                              // } else {
                              await controller.buyMobileData(
                                  network: controller.selectedNetwork.value
                                      .toLowerCase(),
                                  recipient: controller.phoneController.text,
                                  plan: plan.planCode,
                                  amount: plan.amount.toString());
                              // }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Get.find<AppController>().isDarkMode()
                                  ? Colors.black12
                                  : Colors.grey[100],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '₦${plan.amount}',
                                  style: const TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                                const Gap(5),
                                Text(
                                  nameList.length == 1
                                      ? nameList[0].split(' ')[0]
                                      : gb[0],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  plan.name,
                                  style: const TextStyle(fontSize: 7),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
          ],
        ),
      ),
    );
  }
}

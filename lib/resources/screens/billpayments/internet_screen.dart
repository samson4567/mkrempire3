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

import '../../../app/controllers/app_controller.dart';
import '../../../config/app_colors.dart';

class InternetScreen extends StatefulWidget {
  const InternetScreen({super.key});

  @override
  State<InternetScreen> createState() => _InternetScreenState();
}

class _InternetScreenState extends State<InternetScreen> {
  BillPaymentsController controller = Get.find<BillPaymentsController>();
  bool showFirstScreen = true;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await controller.fetchOtherServices(service: 'internet');
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Internet',
        ),
        body: showFirstScreen
            ? Container(
                padding: EdgeInsets.only(top: 10),
                child: Obx(() {
                  return controller.isLoading.value == true
                      ? CustomLoading()
                      : Column(
                          children: [
                            // Container(
                            //   height: 200,
                            //   child: CustomAdvertSliders2(),
                            // ),
                            30.verticalSpace,
                            SizedBox(
                              height: 100.h,
                              child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  shrinkWrap: true,
                                  itemCount: controller.services
                                      .where((service) =>
                                          service.id == 'spectranet')
                                      .length,
                                  itemBuilder: (context, int index) {
                                    final services = controller.services
                                        .where((service) =>
                                            service.id == 'spectranet')
                                        .toList()[index];

                                    print(services.title);
                                    return InkWell(
                                      onTap: () {
                                        controller.serviceID.value =
                                            services.id;
                                        if (controller.serviceID.value ==
                                            'spectranet') {
                                          controller.fetchSpectranetPlans();
                                        }
                                        setState(() {
                                          showFirstScreen = !showFirstScreen;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.secondaryColor
                                                .withOpacity(0.01),
                                            borderRadius: BorderRadius.circular(12)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.network(
                                                  services.logoUrl,
                                                  width: 90,
                                                  height: 90,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Icon(
                                                        Icons.broken_image,
                                                        size: 30,
                                                        color: Colors.grey);
                                                  },
                                                ),
                                                Gap(10),
                                                Text(
                                                  services.title.toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                )
                                              ],
                                            ),
                                            // Icon(Icons.arrow_forward_ios)
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            // 40.verticalSpace,
                            // Container(
                            //   height: 200,
                            //   child: CustomAdvertSliders(),
                            // ),
                          ],
                        );
                }),
                // ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: [
                        CustomTextField(
                          hintText: 'Enter Quantity',
                          controller: controller.customerIDController.value,
                          keyboardType: TextInputType.number,
                        ),
                        Gap(30),
                        Obx(() {
                          return controller.isLoadings.value
                              ? CustomLoading()
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.1,
                                  ),
                                  itemCount: controller.specPlan.length,
                                  itemBuilder: (context, index) {
                                    final plan = controller.specPlan[index];
                                    final nameList = plan['title'];
                                    // final nameList2 = nameList;
                                    // final gb = nameList2[0].split(' ');

                                    return InkWell(
                                      onTap: () async {
                                        final AuthController authController =
                                            Get.find();
                                        if (controller.customerIDController
                                            .value.text.isEmpty) {
                                          CustomDialog.showWarning(
                                            context: context,
                                            message: 'Please Enter Quantity',
                                            buttonText: 'Close',
                                          );
                                          return;
                                        } else {
                                          // if (!authController
                                          //     .canProcessTransaction(
                                          //         plan['amount'])) {
                                          //   CustomDialog.showWarning(
                                          //       context: context,
                                          //       message:
                                          //           'Insufficient Balance for this transaction',
                                          //       buttonText: 'Close');
                                          // } else {
                                          final qty = int.tryParse(controller
                                              .customerIDController.value.text);
                                          await controller
                                              .purchaseSpectranetPlan(
                                            planId: plan['id'],
                                            qty: qty!,
                                          );
                                          controller.customerIDController.value
                                              .clear();
                                        }
                                        // }
                                      },
                                      child: Container(
                                        height: 70.h,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 4),
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Get.find<AppController>()
                                                  .isDarkMode()
                                              ? Colors.black12
                                              : Colors.grey[100],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              nameList,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.secondaryColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                            const Gap(5),
                                            Text(
                                              '₦${plan['amount']}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
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
                ],
              ));
  }
}

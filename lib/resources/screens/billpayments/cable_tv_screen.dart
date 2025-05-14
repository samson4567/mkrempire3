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

class CableTvScreen extends StatefulWidget {
  const CableTvScreen({super.key});

  @override
  State<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends State<CableTvScreen> {
  BillPaymentsController controller = Get.find<BillPaymentsController>();
  bool showFirstScreen = true;
  int month = 1;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await controller.fetchOtherServices(service: 'tv');
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Cable TV',
        ),
        body: showFirstScreen
            ? Container(
                padding: EdgeInsets.only(top: 10),
                child: Obx(() {
                  return controller.isLoading.value == true
                      ? CustomLoading()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          shrinkWrap: true,
                          itemCount: controller.services.length,
                          itemBuilder: (context, int index) {
                            final services = controller.services[index];
                            print(services.title);
                            return InkWell(
                              onTap: () {
                                controller.betID.value = services.id;
                                controller.fetchBouquets(
                                    serviceId: controller.betID.value);
                                setState(() {
                                  showFirstScreen = !showFirstScreen;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
                                margin: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          services.logoUrl,
                                          width: 70,
                                          height: 70,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.broken_image,
                                                size: 30, color: Colors.grey);
                                          },
                                        ),
                                        Gap(10),
                                        Text(services.title.toUpperCase())
                                      ],
                                    ),
                                    // Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                            );
                          });
                }),
                // ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'Customer ID',
                        controller: controller.customerIDController.value,
                      ),
                      Gap(30),
                      Obx(() {
                        return controller.isFetching.value
                            ? CustomLoading()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.1,
                                ),
                                itemCount: controller.bouquets.length,
                                itemBuilder: (context, index) {
                                  final plan = controller.bouquets[index];
                                  final nameList = plan['name'];
                                  // final nameList2 = nameList;
                                  // final gb = nameList2[0].split(' ');

                                  return InkWell(
                                    onTap: () async {
                                      final AuthController authController =
                                          Get.find();
                                      if (controller.customerIDController.value
                                          .text.isEmpty) {
                                        CustomDialog.showWarning(
                                          context: context,
                                          message: 'Please Enter Custom Id',
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
                                        // Default to 1 month
                                        if (plan['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains('annual') ||
                                            plan['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains('yearly')) {
                                          month = 12;
                                        } else if (plan['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains('quarterly')) {
                                          month = 4;
                                        }

                                        print(
                                            "Plan name: ${plan['name'].toString().toLowerCase()}");
                                        print(
                                            "Contains 'yearly': ${plan['name'].toString().toLowerCase().contains('yearly')}");
                                        print(
                                            "Contains 'annual': ${plan['name'].toString().toLowerCase().contains('annual')}");
                                        await controller
                                            .validateSmartcardNumber(
                                          serviceId: controller.betID.value,
                                          planId: plan['id'],
                                          customerId: controller
                                              .customerIDController.value.text,
                                          amount: plan['amount'].toString(),
                                          month: month,
                                        );
                                        // }
                                      }
                                    },
                                    child: Container(
                                      height: 70.h,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 2),
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
                                            overflow: TextOverflow.visible,
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
              ));
  }
}

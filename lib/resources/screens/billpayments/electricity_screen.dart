import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/bill_payments_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_advert_sliders.dart';
import 'package:mkrempire/resources/widgets/custom_advert_text_slider.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  BillPaymentsController controller = Get.find<BillPaymentsController>();
  bool showFirstScreen = true;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (controller.isLoading.value) {
      controller.isLoading.value = false;
    }
    await controller.fetchOtherServices(service: 'electricity');
  }

  void _showMeterTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3, // Default height (30% of screen)
          minChildSize: 0.2, // Minimum height (20% of screen)
          maxChildSize: 0.7, // Maximum height (70% of screen)
          expand: false,
          builder: (context, scrollController) {
            return Obx(() {
              return controller.isLoading.value == true
                  ? CustomLoading()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.meterTypes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              controller.selectedMeterTypes.value =
                                  controller.meterTypes[index];
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Gap(10),
                                  Text(
                                    controller.meterTypes[index],
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Gap(20),
                                ],
                              ),
                            ));
                      });
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Electricity',
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
                                controller.serviceID.value = services.id;
                                setState(() {
                                  showFirstScreen = !showFirstScreen;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(vertical: 6),
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
                                                size: 70, color: Colors.grey);
                                          },
                                        ),
                                        Gap(20),
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
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: [
                        Gap(20),
                        Text('Select Meter Type'),
                        Gap(10),
                        InkWell(
                          onTap: _showMeterTypeBottomSheet,
                          child: Container(
                            margin: EdgeInsets.all(1),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color:
                                    AppColors.textFieldHintColor.withAlpha(12),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Text(
                                      controller.selectedMeterTypes.value);
                                }),
                                Icon(Icons.arrow_drop_down_circle)
                              ],
                            ),
                          ),
                        ),
                        Gap(20),
                        Text('Meter Number'),
                        Gap(10),
                        CustomTextField(
                          hintText: 'Meter Number',
                          controller: controller.meterNumberController,
                        ),
                        Gap(20),
                        Text('Amount to pay'),
                        Gap(10),
                        CustomTextField(
                          hintText: 'Amount',
                          controller: controller.electamountController,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Obx(() {
                      return CustomAppButton(
                          onTap: () async {
                            final AuthController authController = Get.find();
                            if (controller.meterNumberController.text.isEmpty ||
                                controller.electamountController.text.isEmpty) {
                              CustomDialog.showWarning(
                                  context: context,
                                  message: 'Fields required',
                                  buttonText: 'Cancel');
                            } else {
                              // if (!authController.canProcessTransaction(
                              //     controller.electamountController.text)) {
                              //   CustomDialog.showWarning(
                              //       context: context,
                              //       message:
                              //           'Insufficient Balance for this transaction',
                              //       buttonText: 'Close');
                              // } else {
                              await controller.payElectricity();
                              // }
                            }
                          },
                          isLoading: controller.isLoading.value == true,
                          text: 'Pay Electricity');
                    }),
                  ),
                ],
              ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/bill_payments_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_bottom_sheet.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPaymentsController>(builder: (controller) {
      controller.context = context;
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Airtime',
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(30),
                    const Text(
                      'Enter your phone number to buy a discounted Airtime',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Gap(50),
                    const Text('Phone Number', style: TextStyle(fontSize: 14)),
                    const Gap(10),
                    CustomTextField(
                      hintText: 'Phone number',
                      controller: controller.airtphoneController,
                    ),
                    const Gap(30),
                    const Text('Select Mobile Network',
                        style: TextStyle(fontSize: 14)),
                    const Gap(10),
                    Obx(() {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColors.fillColorColor,
                        ),
                        child: InkWell(
                          onTap: () {
                            CustomBottomSheet(
                              children: [
                                _buildNetworkOption('MTN'),
                                const SizedBox(height: 30),
                                _buildNetworkOption('AIRTEL'),
                                const SizedBox(height: 30),
                                _buildNetworkOption('GLO'),
                                const SizedBox(height: 30),
                                _buildNetworkOption('9MOBILE'),
                              ],
                            ).show(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: SvgPicture.asset(
                                      'assets/svgs/${controller.selectedNetwork.value.toLowerCase()}.svg',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const Gap(3),
                                  Text(controller.selectedNetwork.value,
                                      style: TextStyle(
                                        color: Get.find<AppController>()
                                                    .isDarkMode() ==
                                                true
                                            ? Colors.white
                                            : Colors.black,
                                      ))
                                ],
                              ),
                              const Icon(Icons.arrow_drop_down_sharp),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Gap(30),
                    const Text('Amount to Purchase',
                        style: TextStyle(fontSize: 14)),
                    const Gap(10),
                    CustomTextField(
                      hintText: 'Amount',
                      controller: controller.amountController,
                    ),
                    const Gap(50),
                  ],
                ),
              ),
            ),
            Obx(() {
              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: CustomAppButton(
                  isLoading: controller.isLoading.value == true,
                  onTap: () async {
                    final AuthController authController = Get.find();
                    var amount =
                        double.tryParse(controller.amountController.text);
                    if (controller.amountController.text.isEmpty ||
                        controller.airtphoneController.text.isEmpty) {
                      CustomDialog.showWarning(
                          context: context,
                          message: "Fill all fields",
                          buttonText: 'Close');
                    } else {
                      if (!authController.canProcessTransaction(amount)) {
                        CustomDialog.showWarning(
                            context: context,
                            message:
                                'Insufficient Balance for this transaction',
                            buttonText: 'Close');
                      } else {
                        await controller.purchaseAitrtime();
                      }
                    }
                  },
                  text: "Purchase Airtime",
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildNetworkOption(String network) {
    return InkWell(
      onTap: () {
        // setState(() {
        Get.find<BillPaymentsController>().selectedNetwork.value = network;
        // });
        Get.back();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: SvgPicture.asset(
              'assets/svgs/${network.toLowerCase()}.svg',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
          const Gap(8),
          Text(network,
              style: TextStyle(
                color: Colors.black,
              )),
        ],
      ),
    );
  }

  //  final balanceController = Get.find<AuthController>();
}

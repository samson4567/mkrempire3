import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class BettingScreen extends StatefulWidget {
  const BettingScreen({super.key});

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  BillPaymentsController controller = Get.find<BillPaymentsController>();
  bool showFirstScreen = true;
  final RxBool isNameFetched = false.obs;
  var accountNumber = ''.obs;
  @override
  void initState() {
    super.initState();
    ever(controller.customerName, (accountName) {
      controller.customerNameController.text = accountName;
      isNameFetched.value = accountName.isNotEmpty;
    });

    controller.customerIDController.value.addListener(() {
      accountNumber.value = controller.customerIDController.value.text;
      if (accountNumber.value.length < 4) {
        controller.customerName.value = '';
        return;
      }
      controller.validateBetAccount(
          betId: controller.betID.value, accountNumber: accountNumber.value);
    });
    controller.customerNameController.addListener(() {
      controller.customerName.value = controller.customerNameController.text;
    });
    _init();
  }

  Future<void> _init() async {
    await controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Betting',
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
                          itemCount: controller.betProviders.length,
                          itemBuilder: (context, int index) {
                            final services = controller.betProviders[index];
                            print(services.name);
                            print(services.imageAsset);
                            return InkWell(
                              onTap: () {
                                controller.betID.value = services.id;
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
                                        Image.asset(services.imageAsset,
                                            width: 70, height: 70, errorBuilder:
                                                (context, error, stackTrace) {
                                          return SvgPicture.asset(
                                            'assets/svgs/bet.svg',
                                            width: 70,
                                            height: 70,
                                            color: Get.isDarkMode
                                                ? AppColors.black20
                                                : AppColors.black80,
                                          );
                                        }),
                                        Gap(20),
                                        Text(
                                          services.name.toUpperCase(),
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
                        CustomTextField(
                          hintText: 'Customer ID',
                          controller: controller.customerIDController.value,
                          onSubmitted: (value) {
                            // This triggers when user presses Enter/Done button
                            // The keyboard automatically closes
                            // Now validate the account if length is sufficient
                            accountNumber.value = value;
                            if (accountNumber.value.length >= 4) {
                              controller.validateBetAccount(
                                  betId: controller.betID.value,
                                  accountNumber: accountNumber.value);
                            } else if (accountNumber.value.isNotEmpty) {
                              controller.customerName.value = '';
                              // You could show a message that ID is too short here
                            }
                          },
                        ),
                        Gap(10),
                        Obx(() => controller.isValidating.value == true
                            ? Padding(
                                padding: EdgeInsets.only(left: 12.w),
                                child: Row(
                                  children: [
                                    Text(
                                      'Loading...',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                      height: 10.h,
                                      child: CircularProgressIndicator(
                                        color: Get.isDarkMode
                                            ? AppColors.secondaryColor
                                            : AppColors.mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : isNameFetched == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(controller.customerName.value),
                                    ],
                                  )
                                : SizedBox.shrink()),
                        Gap(10),
                        CustomTextField(
                          hintText: 'Amount',
                          controller: controller.amountController,
                        ),
                      ],
                    ),
                  ),
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: CustomAppButton(
                            onTap: () {
                              final AuthController authController = Get.find();
                              if (controller
                                  .customerIDController.value.text.isEmpty) {
                                CustomDialog.showWarning(
                                    context: context,
                                    message: 'Customer ID Required',
                                    buttonText: 'Cancel');
                              } else if (controller
                                  .amountController.text.isEmpty) {
                                CustomDialog.showWarning(
                                    context: context,
                                    message: 'Amount is Required',
                                    buttonText: 'Cancel');
                              } else {
                                // Process the transaction
                                var amount = double.tryParse(
                                    controller.amountController.text);
                                // if (!authController
                                //     .canProcessTransaction(amount)) {
                                //   CustomDialog.showWarning(
                                //       context: context,
                                //       message:
                                //           'Insufficient Balance for this transaction',
                                //       buttonText: 'Close');

                                // } else {
                                int? parsedAmount = amount != null
                                    ? (int.tryParse(amount.toString()) ?? 0) // If parsing fails, default to 0
                                    : 0; // If amount is null, default to 0

                                print("Parsed amount: $parsedAmount");
                                controller.placeBet(
                                  betId: controller.betID.value.toLowerCase(),
                                  accountNumber: controller
                                      .customerIDController.value.text,
                                  amount: amount!,
                                  customer_name: controller.customerName.value,
                                );
                                // controller.customerIDController.value.clear();
                                // controller.amountController.clear();
                              }
                            },
                            // },
                            isLoading: controller.isfundValidating.value,
                            text: 'Fund Wallet'),
                      )),
                ],
              ));
  }
}

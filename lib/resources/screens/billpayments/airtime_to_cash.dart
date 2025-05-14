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

class TransferToOtherBank extends StatefulWidget {
  const TransferToOtherBank({super.key});

  @override
  State<TransferToOtherBank> createState() => _TransferToOtherBankState();
}

class _TransferToOtherBankState extends State<TransferToOtherBank> {
  BillPaymentsController controller = Get.find<BillPaymentsController>();
  bool showFirstScreen = true;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // await controller.fetchServices(service: 'internet');
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: const CustomAppBar(
          // title: 'Transfer to other Bank',
          title: 'Withdraw to other Bank',
        ),
        body: showFirstScreen
            ? Center(
                // padding: EdgeInsets.only(top: 10),
                child: Text("Withdraw to other bank"),
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
                        ),
                        Gap(20),
                        CustomTextField(
                          hintText: 'Amount',
                          controller: controller.amountController,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Obx(() {
                      return CustomAppButton(
                          onTap: () {
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
                            }
                          },
                          isLoading: controller.isLoading.value == true,
                          text: 'Fund Wallet');
                    }),
                  ),
                ],
              ));
  }
}

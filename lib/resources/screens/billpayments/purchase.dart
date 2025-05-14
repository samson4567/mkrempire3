import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/waecController.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PurchasePins extends StatefulWidget {
  final String id;
  final String amount;
  const PurchasePins({
    super.key,
    required this.id,
    required this.amount,
  });

  @override
  State<PurchasePins> createState() => _PurchasePinsState();
}

class _PurchasePinsState extends State<PurchasePins> {
  @override
  Widget build(BuildContext context) {
    Get.put(Waeccontroller());
    return GetBuilder<Waeccontroller>(builder: (waecCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.id.toUpperCase(),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomTextField(
                  hintText: 'Enter Quantity',
                  keyboardType: TextInputType.number,
                  controller: waecCtrl.qtyController,
                  onChanged: (value) {
                    waecCtrl.quantity.value = waecCtrl.qtyController.text;
                  },
                ),
                Gap(20),
                Text(
                  'Exam Type',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Gap(5),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  width: double.infinity,
                  height: 0.05.sh,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                      border: Border.all(
                          width: 0,
                          color: Get.isDarkMode
                              ? AppColors.black70
                              : Colors.grey.shade200)),
                  child: Text(
                    widget.id.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Gap(0.5.sh),
                Obx(() => CustomAppButton(
                    bgColor: waecCtrl.quantity.value.isEmpty
                        ? Get.isDarkMode
                            ? AppColors.secondaryColor.withOpacity(0.3)
                            : AppColors.mainColor.withOpacity(0.3)
                        : Get.isDarkMode
                            ? AppColors.secondaryColor
                            : AppColors.mainColor,
                    isLoading: waecCtrl.isPurchasing.value,
                    onTap: waecCtrl.quantity.value.isEmpty
                        ? null
                        : () {
                            int quantity = int.parse(waecCtrl.quantity.value);
                            String amount =
                                (double.parse(widget.amount) * quantity)
                                    .toString();
                            waecCtrl.purchasePins(
                                qty: quantity, id: widget.id, amount: amount);
                          }))
              ],
            ),
          ),
        )),
      );
    });
  }
}

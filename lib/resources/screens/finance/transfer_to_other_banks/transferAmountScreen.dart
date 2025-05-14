import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/transferController.dart';
import '../../../../app/helpers/hive_helper.dart';
import '../../../../app/helpers/keys.dart';
import '../../../../config/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_textfield.dart';

class TransferAmountScreen extends StatefulWidget {
  final String accountName;
  final String accountNumber;
  final String? bankName;
  final VoidCallback onBack;
  final bool ismkrempireAccount;
  final String? bankCode;
  const TransferAmountScreen(
      {super.key,
      required this.accountName,
      required this.accountNumber,
      this.bankName,
      required this.onBack,
      this.ismkrempireAccount = false,
      this.bankCode});

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    amountController.addListener(() {
      setState(() {
        isButtonEnabled = amountController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<Transfercontroller>(builder: (transferCtrl) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Account Name:', style: t.bodyMedium),
                Spacer(),
                Expanded(
                  child: Text(
                    widget.accountName.toUpperCase(),
                    style: t.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            5.verticalSpace,
            if (!widget.ismkrempireAccount) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bank Name:",
                    style: t.bodyMedium,
                  ),
                  Text(
                    widget.bankName ?? '',
                    style: t.bodySmall,
                  )
                ],
              )
            ],
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Account Number: ",
                  style: t.bodyMedium,
                ),
                Text(
                  widget.accountNumber,
                  style: t.bodySmall,
                )
              ],
            ),
            20.verticalSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0.sp),
              height: 0.3.sh,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? AppColors.black70.withOpacity(0.3)
                    : AppColors.mainColor.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount', style: t.bodyMedium),
                  10.verticalSpace,
                  CustomTextField(
                    hintText: 'Enter Amount',
                    controller: amountController,
                  ),
                  HiveHelper.read(Keys.tier) != '2' ? const Text(
                      'Kindly verify your kyc to withdraw more than NGN 50k',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.red,
                    fontSize: 12
                  ),
                  ): SizedBox(),
                  20.verticalSpace,
                  Text('Remark', style: t.bodyMedium),
                  10.verticalSpace,
                  CustomTextField(
                    hintText:
                        'Enter Remark (optional)', // Fixed from hintext to hintText
                    controller: remarkController,
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Obx(() => Container(
                  color: Colors.transparent,
                  child: CustomAppButton(
                    isLoading: transferCtrl.isfetching.value == true,
                    onTap: isButtonEnabled
                        ? () async {
                            if( double.parse(amountController.text) > 50000.00 &&
                                HiveHelper.read(Keys.tier) != '2' ){
                              CustomDialog.showWarning(context: context,
                                  message: 'Kindly verify your kyc to withdraw more than NGN 50k',
                                  buttonText: "Cancel");
                              return;
                            }
                            if (!widget.ismkrempireAccount) {
                              await transferCtrl.payOutFee(
                                  amount: amountController.text);
                              print('BankCode ${widget.bankCode}');
                            }
                            await showModalBottomSheet(
                              context: context,
                              builder: (c) {
                                return Container(
                                  padding: EdgeInsets.all(16.0.sp),
                                  height: 0.4.sh,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 20.sp,
                                          )),
                                      20.verticalSpace,
                                      if (!widget.ismkrempireAccount) ...[
                                        10.verticalSpace,
                                        Row(
                                          children: [
                                            Text(
                                              'Bank',
                                              style: t.bodySmall,
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.bankName ?? '',
                                              style: t.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                      10.verticalSpace,
                                      Row(
                                        children: [
                                          Text(
                                            'Account Number',
                                            style: t.bodySmall,
                                          ),
                                          Spacer(),
                                          Text(
                                            widget.accountNumber,
                                            style: t.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      10.verticalSpace,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Account Name',
                                            style: t.bodySmall,
                                          ),
                                          Spacer(),
                                          Expanded(
                                            child: Text(
                                              widget.accountName,
                                              style: t.bodyMedium,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      10.verticalSpace,
                                      Row(
                                        children: [
                                          Text(
                                            'Amount',
                                            style: t.bodySmall,
                                          ),
                                          Spacer(),
                                          Text(
                                            '${transferCtrl.currency.value.toUpperCase()} ${amountController.text}',
                                            style: t.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      if (!widget.ismkrempireAccount) ...[
                                        10.verticalSpace,
                                        Row(
                                          children: [
                                            Text(
                                              'Transaction fee',
                                              style: t.bodySmall,
                                            ),
                                            Spacer(),
                                            Text(
                                              '₦ ${transferCtrl.fee.value}',
                                              style: t.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                      40.verticalSpace,
                                      Obx(() => Container(
                                            color: Colors.transparent,
                                            child: CustomAppButton(
                                              isLoading: transferCtrl
                                                  .isTransferring.value,
                                              onTap: () {
                                                String narration =
                                                    remarkController
                                                            .text.isEmpty
                                                        ? 'none'
                                                        : remarkController.text;
                                                String totalAmount = widget
                                                        .ismkrempireAccount
                                                    ? amountController.text
                                                    : (double.parse(
                                                                amountController
                                                                    .text) +
                                                            double.parse(
                                                                transferCtrl
                                                                    .fee.value
                                                                    .toString()))
                                                        .toString();
                                                String currency =
                                                    widget.ismkrempireAccount
                                                        ? "ngn"
                                                        : transferCtrl
                                                            .currency.value;

                                                transferCtrl.transfer(
                                                    amount: totalAmount,
                                                    bank: widget.bankCode ?? '',
                                                    account:
                                                        widget.accountNumber,
                                                    currencies: currency,
                                                    narration: narration);
                                              },
                                              text: 'Confirm',
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    bgColor: Get.isDarkMode
                        ? isButtonEnabled
                            ? AppColors.secondaryColor
                            : AppColors.secondaryColor.withOpacity(0.5)
                        : isButtonEnabled
                            ? AppColors.mainColor
                            : AppColors.mainColor.withOpacity(0.5),
                    text: 'Continue',
                  ),
                )),
          ],
        ),
      );
    });
  }
}

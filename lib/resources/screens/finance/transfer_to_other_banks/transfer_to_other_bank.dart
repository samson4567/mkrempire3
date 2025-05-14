import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/bill_payments_controller.dart';
import 'package:mkrempire/app/controllers/transferController.dart';
import 'package:mkrempire/resources/screens/finance/transfer_to_other_banks/transferAmountScreen.dart';
import 'package:mkrempire/resources/widgets/custom_advert_sliders.dart';
import 'package:mkrempire/resources/widgets/custom_advert_text_slider.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/resources/widgets/custom_textfield.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../app/helpers/hive_helper.dart';
import '../../../../app/helpers/keys.dart';
import '../../../../app/repository/bank_repo.dart';
import '../../../../config/app_colors.dart';

class TransferToOtherBank extends StatefulWidget {
  const TransferToOtherBank({super.key});

  @override
  State<TransferToOtherBank> createState() => _TransferToOtherBankState();
}

class _TransferToOtherBankState extends State<TransferToOtherBank> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final Rxn<String> selectedValue = Rxn<String>();
  final Rxn<String> selectedBankCode = Rxn<String>();
  var accountName = ''.obs;
  var accountNumber = ''.obs;
  final RxBool isNameFetched = false.obs;
  final Transfercontroller transferController = Get.put(Transfercontroller());

  // Page controller for the PageView
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ever(transferController.accountName, (accountName) {
      nameController.text = accountName;
      isNameFetched.value = accountName.isNotEmpty;
    });

    accountController.addListener(() {
      accountNumber.value = accountController.text;
      if (accountNumber.value.length < 10) {
        transferController.accountName.value = '';
        return;
      }
      if (selectedValue.value != null && accountNumber.value.length == 10) {
        // Get the selected bank's code
        BanksController bankCtrl = Get.find();
        final selectedBank = bankCtrl.banks.firstWhere(
          (bank) => bank['bankName'] == selectedValue.value,
          orElse: () => {'bankName': '', 'nibssBankCode': ''},
        );
        selectedBankCode.value = selectedBank['nibssBankCode'];

        transferController.accountLookup(
            acctNo: accountNumber.value,
            bank: selectedBank['nibssBankCode']); // Pass bank CODE, not name
      } else {}
    });
    nameController.addListener(() {
      transferController.accountName.value = nameController.text;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BanksController());
    // TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<BanksController>(builder: (bankCtrl) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Withdraw to other Bank',
        ),
        body: SafeArea(
          child: PageView.builder(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 15.r,
                              backgroundColor: Get.isDarkMode
                                  ? AppColors.secondaryColor.withOpacity(0.3)
                                  : AppColors.mainColor.withOpacity(0.3),
                              child: Icon(
                                Icons.bolt,
                                size: 20.sp,
                                color: AppColors.bgColor,
                              )),
                          10.horizontalSpace,
                          const Expanded(child: Text(
                            'Make sure your withdrawal account name is the same with your User Full Name',
                            // 'Make Fast, Reliable and Stress Free Transfers....',
                            // style: Theme.of(context)
                            //     .textTheme
                            //     .bodyMedium!
                            //     .copyWith(fontStyle: FontStyle.italic),
                            style: TextStyle(fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines:2,

                          )),
                        ],
                      ),
                      25.verticalSpace,
                      Container(
                          width: double.infinity,
                          height: 80,
                          child: CustomAdvertTextSlider()),
                      30.verticalSpace,
                      Obx(
                        () => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0.sp),
                          height: isNameFetched == true ? 0.35.sh : 0.27.sh,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.r)),
                            color: Get.isDarkMode
                                ? AppColors.black70.withOpacity(0.3)
                                : AppColors.mainColor.withOpacity(0.05),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recipient Account",
                                // style: t.bodyLarge,
                              ),
                              Gap(20),
                              CustomTextField(
                                hintText: 'Enter 10 digits Account Number',
                                keyboardType: TextInputType.number,
                                controller: accountController,
                              ),
                              Gap(20),
                              Obx(() => BankDropdown(
                                    selectedValue: selectedValue.value,
                                    items: bankCtrl.banks,
                                    onChanged: (value) {
                                      selectedValue.value = value;
                                      if (accountNumber.value.length == 10) {
                                        // Get the selected bank's code
                                        final selectedBank =
                                            bankCtrl.banks.firstWhere(
                                          (bank) => bank['bankName'] == value,
                                          orElse: () =>
                                              {'bankName': '', 'nibssBankCode': ''},
                                        );
                                        selectedBankCode.value =
                                            selectedBank['nibssBankCode'];
                                        transferController.accountLookup(
                                          acctNo: accountController.text,
                                          bank: selectedBank['nibssBankCode'],
                                        );
                                      }
                                    },
                                  )),
                              Gap(5),
                              Obx((){
                                String firstName = HiveHelper.read(Keys.firstName).toString().toUpperCase(); // e.g., "CHIBUIKE"
                                String lastName = HiveHelper.read(Keys.lastName).toString().toUpperCase();   // e.g., "NWACHUKWU"
                                String fullName = transferController
                                    .accountName.value
                                    .toUpperCase();
                                List<String> fullNameParts = fullName.split(' ');
                                bool isMatch = (firstName == fullNameParts[0] && lastName == fullNameParts[fullNameParts.length-1]) ||
                                    (lastName == fullNameParts[0] && firstName == fullNameParts[fullNameParts.length-1]);

                                return transferController.isLooking.value == true
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 12.w),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Loading...',
                                              // style: t.bodySmall,
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
                                      ?
                                isMatch == false ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:Colors.red.withOpacity(0.5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                      color: Colors.red
                                          .withOpacity(0.3),
                                      width: 0,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        transferController
                                            .accountName.value
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: AppColors.bgColor,
                                        ),
                                      ),
                                      5.verticalSpace,
                                      Text(
                                       "Account Verification failed! Account does not belong to user",
                                        style: TextStyle(
                                          color: AppColors.bgColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      // 10.verticalSpace,
                                    ],
                                  ),
                                ) : GestureDetector(
                                            onTap: () {
                                              // Navigate to the next page with animation
                                              _pageController.animateToPage(
                                                1,
                                                duration:
                                                    Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );

                                              // print();
                                              print(
                                                  'Bank Code: $selectedBankCode');
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Get.isDarkMode
                                                    ? AppColors.secondaryColor
                                                        .withOpacity(0.3)
                                                    : AppColors.mainColor
                                                        .withOpacity(0.5),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                border: Border.all(
                                                  color: Get.isDarkMode
                                                      ? AppColors.secondaryColor
                                                          .withOpacity(0.3)
                                                      : AppColors.mainColor
                                                          .withOpacity(0.1),
                                                  width: 0,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    transferController
                                                        .accountName.value
                                                        .toUpperCase(),
                                                    style:TextStyle(
                                                      color: AppColors.bgColor,
                                                    ),
                                                  ),
                                                  10.verticalSpace,
                                                  Text(
                                                    accountNumber.value,
                                                    style:TextStyle(
                                                      color: AppColors.bgColor,
                                                    ),
                                                  ),
                                                  10.verticalSpace,
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink();
      }),
                            ],
                          ),
                        ),
                      ),
                      40.verticalSpace,
                      Container(height: 200.h, child: CustomAdvertSliders()),
                    ],
                  ),
                );
              } else {
                // Second page - Transfer amount screen
                return TransferAmountScreen(
                  accountName: transferController.accountName.value,
                  accountNumber: accountNumber.value,
                  bankName: selectedValue.value ?? '',
                  bankCode: selectedBankCode.value ?? '',
                  onBack: () {
                    // Navigate back to first page
                    _pageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  ismkrempireAccount: false,
                );
              }
            },
          ),
        ),
      );
    });
  }
}

class BankDropdown extends StatelessWidget {
  const BankDropdown({
    Key? key,
    required this.selectedValue,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  final String? selectedValue;
  final List items;
  final Function(String?)? onChanged;

  void _showBankBottomSheet(BuildContext context) {
    // Define searchText outside of the builder to maintain its state
    String searchText = '';
    List filteredItems = List.from(items);
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      // backgroundColor: Get.isDarkMode ? Colors.black : AppColors.black10,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 0.6.sh,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Text(
                    'Select Bank',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16.h),

                  // Search Field
                  CustomTextField(
                    onChanged: (value) {
                      // Use setModalState to update the UI when search text changes
                      setModalState(() {
                        searchText = value;
                        filteredItems = items
                            .where((item) => item['bankName']
                                .toString()
                                .toLowerCase()
                                .contains(searchText.toLowerCase()))
                            .toList();
                      });
                    },
                    hintText: 'Search Bank',
                    controller: searchController,
                    // isPrefixIcon: true,
                    // prefixIcon: 'search',
                  ),
                  SizedBox(height: 16.h),

                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              'No banks found',
                              style: TextStyle(
                                // color: Get.isDarkMode
                                //     ? Colors.white70
                                //     : Colors.black54,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: filteredItems.length,
                            separatorBuilder: (context, index) => SizedBox(),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return ListTile(
                                title: Text(
                                  item['bankName'],
                                  style: TextStyle(
                                    // color: Get.isDarkMode
                                    //     ? Colors.white
                                    //     : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  onChanged?.call(item['bankName']);
                                  Get.back();
                                },
                                selected: selectedValue == item['bankName'],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showBankBottomSheet(context),
          child: Container(
            width: double.infinity,
            height: 0.06.sh,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Get.isDarkMode
                      ? AppColors.black70.withOpacity(0.3)
                      : AppColors.black20.withOpacity(0.3)),
              borderRadius: BorderRadius.all(Radius.circular(14.r)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue ?? 'Select Bank',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

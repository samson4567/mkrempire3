import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mkrempire/app/controllers/history_controller.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:mkrempire/resources/widgets/custom_app_bar.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:mkrempire/resources/widgets/custom_history_category.dart';
import 'package:mkrempire/resources/widgets/custom_history_status.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController controller = Get.find<HistoryController>();

  @override
  void initState() {
    super.initState();
    // Initialize the controller or refresh data when screen loads
    controller.refreshTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'History',
        showBackIcon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              children: [
                // Status Dropdown
                Expanded(
                  child: Obx(() {
                    return InkWell(
                      onTap: () {
                        CustomHistoryStatus.showStatus(
                          context: context,
                          message: 'Select Status',
                          buttonText: 'Apply',
                          buttonAction: (status) {
                            // controller.updateStatus(status);
                            Get.back();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedStatus.value,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                // Category Dropdown
                Expanded(
                  child: Obx(() {
                    return InkWell(
                      onTap: () {
                        CustomHistoryCategory.showCategories(
                          context: context,
                          message: 'Select Category',
                          buttonText: 'Apply',
                          categories: controller.getAvailableCategories(),
                          buttonAction: (category) {
                            controller.updateCategory(category);
                            Get.back();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedCategory.value,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                // Date Picker
                Obx(() {
                  return InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: Get.context!,
                        initialDate:
                            controller.selectedDate.value ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        controller.updateDate(pickedDate);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Text(
                            controller.selectedDate.value == null
                                ? 'Date'
                                : DateFormat('yyyy-MM-dd')
                                    .format(controller.selectedDate.value!),
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today, size: 16),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
            const SizedBox(height: 16),
            // Transaction List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Get.isDarkMode
                          ? AppColors.secondaryColor
                          : AppColors.mainColor,
                    ),
                  );
                }

                if (controller.filteredTransactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No transactions found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        CustomAppButton(
                          onTap: () => controller.refreshTransactions(),
                          text: 'Refresh',
                          buttonWidth: 100.w,
                          buttonHeight: 40.h,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshTransactions(),
                  child: ListView.builder(
                    itemCount: controller.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          controller.filteredTransactions[index];

                      if (transaction['isMonthHeader'] == true) {
                        return Text(
                          transaction['monthName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                      String svgAsset =
                          _getSvgForCategory(transaction['category']);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.secondaryColor.withAlpha(12)
                              : AppColors.mainColor.withAlpha(12),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: transaction['status'] == 'Successful'
                                  ? Colors.green.withOpacity(0.1)
                                  : transaction['status'] == 'Pending'
                                      ? Colors.orange.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: SvgPicture.asset(svgAsset,
                                width: 14,
                                height: 14,
                                color: transaction['status'] == 'Successful'
                                    ? Colors.green
                                    : transaction['status'] == 'Pending'
                                        ? Colors.orange
                                        : Colors.red),
                          ),
                          title: Text(
                            transaction['title'] ?? 'Transaction',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${transaction['date']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                '${transaction['amount']}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: transaction['status'] == 'Successful'
                                      ? Colors.green
                                      : transaction['status'] == 'Pending'
                                          ? Colors.orange
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: transaction['status'] == 'Successful'
                                      ? Colors.green.withOpacity(0.1)
                                      : transaction['status'] == 'Pending'
                                          ? Colors.orange.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  transaction['status'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: transaction['status'] == 'Successful'
                                        ? Colors.green
                                        : transaction['status'] == 'Pending'
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Show transaction details
                            _showTransactionDetails(context, transaction);
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _getSvgForCategory(String category) {
    switch (category) {
      case 'Deposit':
        return 'assets/svgs/deposit2.svg';
      case 'Transfer':
        return 'assets/svgs/transfer.svg';
      case 'Airtime':
        return 'assets/svgs/airtime.svg';
      case 'Data':
        return 'assets/svgs/cellular-data.svg';
      case 'Electricity':
        return 'assets/svgs/electricity.svg';
      case 'Cable TV':
        return 'assets/svgs/tv.svg';
      case 'Internet':
        return 'assets/svgs/internet.svg';
      case 'WAEC/NECO':
        return 'assets/svgs/waec_neco.svg';
      default:
        return 'assets/icons/transaction_other.svg';
    }
  }

  void _showTransactionDetails(
      BuildContext context, Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow('Title', transaction['title'] ?? 'N/A'),
              _detailRow('Amount', '${transaction['amount']}'),
              _detailRow('Category', transaction['category'] ?? 'N/A'),
              _detailRow('Date', transaction['date'] ?? 'N/A'),
              _detailRow('Status', transaction['status'] ?? 'N/A'),
              _detailRow('Transaction ID', transaction['raw']['trx_id']),
              if (transaction['raw'] != null &&
                  transaction['raw']['remarks'] != null &&
                  transaction['raw']['remarks'].isNotEmpty)
                _detailRow('Remarks', transaction['raw']['remarks']),
              const SizedBox(height: 20),
              CustomAppButton(
                bgColor: Get.isDarkMode
                    ? AppColors.secondaryColor
                    : AppColors.mainColor,
                onTap: () {
                  Get.back();
                },
                text: 'Close',
              )
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

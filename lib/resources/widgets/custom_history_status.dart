import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/history_controller.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:get/get.dart';

class CustomHistoryStatus {
  static void showStatus(
      {required BuildContext context,
      required String message,
      String title = 'Success',
      required String buttonText,
      dynamic buttonAction}) {
    _customHistoryStatus(
      context,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      title: title,
      message: message,
      buttonColor: Colors.green,
      buttonText: buttonText,
      buttonAction: buttonAction ?? () => Get.back(),
    );
  }

  static void _customHistoryStatus(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required Color buttonColor,
    required String buttonText,
    required dynamic buttonAction,
  }) {
    final statuses = ['All', 'Successful', 'Pending', 'Failed'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.white,
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
            return ListView.builder(
                itemCount: statuses.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Get.find<HistoryController>().selectedStatus.value =
                          statuses[index];
                      final controller = Get.find<HistoryController>();
                      controller.updateStatus(statuses[index]);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        statuses[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                });

            // DropdownButton<String>(
            //     value: selectedStatus,
            //     items: ['All', 'Completed', 'Pending', 'Failed']
            //         .map((status) => DropdownMenuItem(
            //               value: status,
            //               child: Text(status),
            //             ))
            //         .toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         selectedStatus = value!;
            //       });
            //     },
            //   ),
            // }))

            // SingleChildScrollView(
            //   controller: scrollController,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Icon(
            //           icon,
            //           size: 50,
            //           color: iconColor,
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           title,
            //           style: const TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         Text(
            //           message,
            //           textAlign: TextAlign.center,
            //           style: const TextStyle(fontSize: 14, color: Colors.black87),
            //         ),
            //         const SizedBox(height: 20),
            //         CustomAppButton(
            //           onTap: buttonAction,
            //           text: buttonText,
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }
}

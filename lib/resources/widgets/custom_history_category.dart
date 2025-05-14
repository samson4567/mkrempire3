import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/history_controller.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';

class CustomHistoryCategory {
  static void showCategories(
      {required BuildContext context,
      required String message,
      String title = 'Success',
      required String buttonText,
      required List<String> categories,
      required dynamic buttonAction}) {
    _customHistoryCategory(
      context,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      title: title,
      message: message,
      buttonColor: Colors.green,
      buttonText: buttonText,
      buttonAction: buttonAction ?? () => Get.back(),
      categories: categories,
    );
  }

  static void _customHistoryCategory(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required Color buttonColor,
    required List<String> categories,
    required String buttonText,
    required dynamic buttonAction,
  }) {
    final controller = Get.find<HistoryController>();
    final categoryList = categories ?? controller.getAvailableCategories();

    showModalBottomSheet(
      context: context,
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
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categoryList.map((category) {
                  return InkWell(
                    onTap: () => buttonAction(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: controller.selectedCategory.value == category
                            ? AppColors.mainColor
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: controller.selectedCategory.value == category
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

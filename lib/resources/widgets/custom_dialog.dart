import 'package:flutter/material.dart';
import 'package:mkrempire/resources/widgets/custom_app_button.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class CustomDialog {
  static void showError(
      {required BuildContext context,
      required String message,
      required String buttonText,
      bool isLoading = false,
      dynamic buttonAction}) {
    _showDialog(
      context,
      icon: Icons.error_outline,
      iconColor: Colors.red,
      title: 'Error',
      message: message,
      buttonColor: Colors.red,
      buttonText: buttonText,
      buttonAction: buttonAction ?? () => Get.back(),
      isLoading: isLoading,
    );
  }

  static void showSuccess(
      {required BuildContext context,
      required String message,
      String? electricityToken,
      String title = 'Success',
      required String buttonText,
      bool isLoading = false,
      dynamic buttonAction}) {
    _showDialog(
      electricityToken: electricityToken,
      context,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      title: title,
      message: message,
      buttonColor: Colors.green,
      buttonText: buttonText,
      buttonAction: buttonAction ?? () => Get.back(),
      isLoading: isLoading,
    );
  }

  static void showWarning(
      {required BuildContext context,
      required String message,
      required String buttonText,
      bool isLoading = false,
      dynamic buttonAction}) {
    _showDialog(
      context,
      icon: Icons.warning_amber_outlined,
      iconColor: Colors.orange,
      title: 'Warning',
      message: message,
      buttonColor: Colors.orange,
      buttonText: buttonText,
      buttonAction: buttonAction ?? () => Get.back(),
      isLoading: isLoading,
    );
  }

  static void _showDialog(BuildContext context,
      {required IconData icon,
      String? electricityToken,
      required Color iconColor,
      required String title,
      required String message,
      required Color buttonColor,
      required String buttonText,
      required dynamic buttonAction,
      required bool isLoading}) {
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
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 50,
                      color: iconColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Text(
                    //   message,
                    //   textAlign: TextAlign.center,
                    //   style:
                    //       const TextStyle(fontSize: 14, color: Colors.black87),
                    // ),
                    SizedBox(
                      height: electricityToken != null ? 10 : 0,
                    ),
                    Visibility(
                      visible: electricityToken != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Electricity Token:   ${electricityToken ?? ''}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () async {
                                await _copyToClipBoard(electricityToken ?? '');
                              },
                              icon: const Icon(Icons.copy))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomAppButton(
                      isLoading: isLoading,
                      onTap: buttonAction,
                      text: buttonText,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> _copyToClipBoard(String value) async {
    final data = ClipboardData(text: value);
    await Clipboard.setData(data);
  }
}

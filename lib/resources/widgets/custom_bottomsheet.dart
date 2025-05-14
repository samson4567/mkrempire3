import 'package:flutter/material.dart';

class CustomBottomsheet {


  static void showWidget(
      {
        required BuildContext context,
        required Widget child,
        Color? backgroundColor,
      }) {
    _showDialog(
      context,
      child: child,
      backgroundColor: backgroundColor,
    );
  }

  static void _showDialog(
      BuildContext context, {
        required Widget child,
        Color? backgroundColor,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Default height (30% of screen)
          minChildSize: 0.2, // Minimum height (20% of screen)
          maxChildSize: 0.7, // Maximum height (70% of screen)
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: child,
            );
          },
        );
      },
    );
  }
}

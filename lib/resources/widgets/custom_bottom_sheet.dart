import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;

  CustomBottomSheet({required this.children});

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Ensures full-width design
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width, // Full width
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.3, // Default height (30% of screen)
            minChildSize: 0.2, // Minimum height (20% of screen)
            maxChildSize: 0.7, // Maximum height (70% of screen)
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(); // Not needed for StatelessWidget but kept for consistency
  }
}

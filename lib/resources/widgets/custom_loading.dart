import 'package:flutter/cupertino.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(radius: 15), // Cupertino Loading Indicator
    );
  }
}

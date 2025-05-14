import 'package:flutter/material.dart';
import 'package:mkrempire/config/app_colors.dart';

class CustomizedTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final dynamic? onChanged;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final dynamic? maxLength;

  const CustomizedTextfield({
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.style,
    this.textInputAction,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      onChanged: onChanged,
      style: style ??
          const TextStyle(
            fontSize: 16,
          ),
      // textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffix: suffixIcon,
        // border: Border.only(),
        // borderRadius:BorderRadius.circular(12),
        border: UnderlineInputBorder( // Fallback border
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   // borderSide: BorderSide(color: AppColors.mainColor),
        // ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5), // Default bottom border
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}

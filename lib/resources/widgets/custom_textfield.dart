import 'package:flutter/material.dart';
import 'package:mkrempire/config/app_colors.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final dynamic? onChanged;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final dynamic? maxLength;
  final bool? enabled;
  final bool readOnly;
  final Color? fillColor;
  final bool expands;
  final int? maxlines;
  final Function(String)? onSubmitted;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.style,
    this.textInputAction,
    this.maxLength,
    this.enabled,
    this.readOnly = false,
    this.fillColor,
    this.expands = false,
    this.maxlines = 1,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      maxLines: maxlines,
      expands: expands,
      cursorColor: Get.isDarkMode ? Colors.white : Colors.black,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      onChanged: onChanged,
      readOnly: readOnly,
      enabled: enabled,
      style: style ??
          const TextStyle(
            fontSize: 16,
          ),
      // textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,

          // border: InputBorder.none,
          // borderRadius:BorderRadius.circular(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          fillColor: fillColor),
    );
  }
}

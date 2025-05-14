import 'package:flutter/widgets.dart';
import 'app_colors.dart';

class Styles {
  static const String appFontFamily = 'Afacad';
  static const String secondaryFontFamily = 'Roboto';

  static TextStyle baseStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
  static TextStyle largeTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 30,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w700,
  );
  static TextStyle mediumTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 26,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  static TextStyle smallTitle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 24,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodyLarge = TextStyle(
    color: AppColors.blackColor,
    fontSize: 22,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyMedium = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );
  static TextStyle bodySmall = TextStyle(
    color: AppColors.paragraphColor,
    fontSize: 16,
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );
}

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers_app/constants/app_colors.dart';

class AppTextStyle {
  static final title28 = GoogleFonts.kantumruyPro(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  static final screenTitle24 = GoogleFonts.kantumruyPro(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );
  static final sectionTitle20 =
      GoogleFonts.kantumruyPro(fontSize: 20, fontWeight: FontWeight.w600);
  static final fontsize18 =
      GoogleFonts.kantumruyPro(fontSize: 18, fontWeight: FontWeight.w600);
  static final body =
      GoogleFonts.kantumruyPro(fontSize: 16, fontWeight: FontWeight.w400);
  static final hintText = GoogleFonts.kantumruyPro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryText);
}

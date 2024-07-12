import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  final BuildContext context;

  AppTextStyles(this.context);

  TextStyle get headline1 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get headline2 => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get bodyText1 => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.surface,
  );

  TextStyle get bodyText2 => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.surface,
  );

  static final TextStyle headline3 = GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xff131313));

  static final TextStyle headline4 = GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: const Color(-13157824));

  TextStyle get cardNameStyle => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );

  TextStyle get cardLabelTitle => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get cardLabelDigital => GoogleFonts.robotoMono(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  TextStyle get titleBold => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get discountRed => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.error,
  );

  TextStyle get searchBarText => GoogleFonts.inter(
    fontSize: 18,
    color: Theme.of(context).colorScheme.onSurface
  );
}

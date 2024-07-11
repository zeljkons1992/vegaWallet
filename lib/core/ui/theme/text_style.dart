import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle headline1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color(-13157824),
  );

  static final TextStyle headline2 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(-13157824));

  static final TextStyle headline3 = GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xff131313));

  static final TextStyle headline4 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: const Color(-13157824));

  static final TextStyle bodyText1 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static final TextStyle bodyText2 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static final TextStyle cardNameStyle = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: Colors.white
  );
  static final TextStyle cardLabelTitle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: const Color(-9868951)
  );
  static final TextStyle cardLabelDigital = GoogleFonts.robotoMono(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color:  Colors.white
  );
  static final TextStyle titleBold = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: const Color(0xff373a40)
  );
  static final TextStyle discountRed = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: const Color(0xffb3112b),
  );

}
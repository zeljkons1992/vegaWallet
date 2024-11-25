import 'package:flutter/material.dart';

TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;

  // Define body text theme using PPMori font
  TextTheme bodyTextTheme = baseTextTheme.copyWith(
    bodyLarge: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.bodyLarge?.fontSize,
      fontWeight: FontWeight.normal,
      color: baseTextTheme.bodyLarge?.color,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.bodyMedium?.fontSize,
      fontWeight: FontWeight.normal,
      color: baseTextTheme.bodyMedium?.color,
    ),
    bodySmall: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.bodySmall?.fontSize,
      fontWeight: FontWeight.normal,
      color: baseTextTheme.bodySmall?.color,
    ),
    labelLarge: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.labelLarge?.fontSize,
      fontWeight: FontWeight.normal,
      color: baseTextTheme.labelLarge?.color,
    ),
    labelMedium: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.labelMedium?.fontSize,
      fontWeight: FontWeight.normal,
      color: baseTextTheme.labelMedium?.color,
    ),
    labelSmall: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.labelSmall?.fontSize,
      fontWeight: FontWeight.normal,
      color: baseTextTheme.labelSmall?.color,
    ),
  );

  // For display text theme, fall back to title properties if headline1 to headline6 are not defined
  TextTheme displayTextTheme = baseTextTheme.copyWith(
    titleLarge: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.titleLarge?.fontSize,
      fontWeight: FontWeight.bold,
      color: baseTextTheme.titleLarge?.color,
    ),
    titleMedium: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.titleMedium?.fontSize,
      fontWeight: FontWeight.bold,
      color: baseTextTheme.titleMedium?.color,
    ),
    titleSmall: TextStyle(
      fontFamily: 'PPMori',
      fontSize: baseTextTheme.titleSmall?.fontSize,
      fontWeight: FontWeight.bold,
      color: baseTextTheme.titleSmall?.color,
    ),
  );

  // Combine both text themes
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );

  return textTheme;
}



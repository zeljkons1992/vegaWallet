import 'package:flutter/material.dart';

class AppTextStyles {
  final BuildContext context;

  AppTextStyles(this.context);

  TextStyle get headline1 => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get headline2 => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get bodyText1 => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get bodyText2 => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get headline3 => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get headline4 => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get cardNameStyle => const TextStyle(
    fontFamily: 'PPMori',
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );

  TextStyle get cardLabelTitle => const TextStyle(
    fontFamily: 'PPMori',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle get cardLabelDigital => const TextStyle(
    fontFamily: 'PPMori',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  TextStyle get titleBold => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  TextStyle get discountRed => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.error,
  );

  TextStyle get searchBarText => TextStyle(
    fontFamily: 'PPMori',
    fontSize: 16,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

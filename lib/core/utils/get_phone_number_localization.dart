import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


String getPhoneNumber(String phoneNumber,BuildContext context) {
  if (phoneNumber=="No number") {
    final localization = AppLocalizations.of(context)!;
    return localization.localeName == 'sr' ? 'Nema Broja' : 'No Number';
  }
  return phoneNumber;
}
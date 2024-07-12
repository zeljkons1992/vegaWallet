import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/text_const.dart';


String getPhoneNumber(String phoneNumber,BuildContext context) {
  if (phoneNumber==TextConst.noNumber) {
    final localization = AppLocalizations.of(context)!;
    return localization.noNumber;
  }
  return phoneNumber;
}
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translate(String key, AppLocalizations localization) {
  switch (key) {
    case "invalid_email_domain":
      return localization.invalidEmailDomain;
    case "unknown_error":
      return localization.unknownError;
    case "no_network":
      return localization.noNetwork;
    default:
      return key;
  }
}

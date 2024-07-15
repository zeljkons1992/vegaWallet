import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/constants/assets_const.dart';
import '../../../../../core/ui/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget verificationUnsuccessful(BuildContext context) {
  final localization = AppLocalizations.of(context)!;
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            googleVerUnSuccess,
            width: 200,
            height: 200,
            repeat: false,
          ),
          const SizedBox(height: 16.0),
          Text(
            localization.googleVerUns,
            style: AppTextStyles(context).bodyText1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

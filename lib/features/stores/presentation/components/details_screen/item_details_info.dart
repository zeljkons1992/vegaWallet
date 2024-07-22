import 'package:flutter/material.dart';
import '../../../../../core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Widget itemDetailsInfo(Store store, BuildContext context) {
  final localization = AppLocalizations.of(context)!;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionText(localization.storeDetailsNameLabel, AppTextStyles(context).titleBold.copyWith(fontSize: 14)),
        _buildSectionText(store.name, AppTextStyles(context).titleBold.copyWith(fontSize: 18.0)),
        _buildDivider(context),
        _buildSectionText(localization.discountsTitle, AppTextStyles(context).titleBold.copyWith(fontSize: 14)),
        _buildSectionText("${store.parsedDiscount?.toInt().toString()}%", AppTextStyles(context).headline2.copyWith(fontSize: 14.0)),
        _buildDivider(context),
        _buildSectionText(localization.discountCalculatorConditionsTitle, AppTextStyles(context).titleBold.copyWith(fontSize: 14)),
        _buildSectionText(_formatList(store.conditions), AppTextStyles(context).headline2.copyWith(fontSize: 14.0)),
      ],
    ),
  );
}


Widget _buildSectionText(String content,TextStyle appTextStyle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(content, style: appTextStyle,),
  );
}

Widget _buildDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Divider(
      height: 1,
      color: Theme.of(context).primaryColor,
    ),
  );
}

String _formatList(List<dynamic> list) {
  return list.join(', ');
}

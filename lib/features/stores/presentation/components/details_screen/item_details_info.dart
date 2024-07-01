import 'package:flutter/material.dart';
import '../../../../../core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';

Widget itemDetailsInfo(Store store, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionText("Naziv objekta",AppTextStyles.titleBold.copyWith(fontSize: 14)),
        _buildSectionText(store.name,AppTextStyles.titleBold.copyWith(fontSize: 18.0)),
        _buildDivider(context),
        _buildSectionText("Popusti",AppTextStyles.titleBold.copyWith(fontSize: 14)),
        _buildSectionText(_formatList(store.discounts),AppTextStyles.headline2.copyWith(fontSize: 14.0)),
        _buildDivider(context),
        _buildSectionText("Uslovi",AppTextStyles.titleBold.copyWith(fontSize: 14)),
        _buildSectionText(_formatList(store.conditions),AppTextStyles.headline2.copyWith(fontSize: 14.0)),
      ],
    ),
  );
}


Widget _buildSectionText(String content,TextStyle appTextStyle) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(content,style: appTextStyle,),
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

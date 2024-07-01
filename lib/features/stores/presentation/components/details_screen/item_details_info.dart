import 'package:flutter/material.dart';
import '../../../../../core/ui/theme/text_style.dart';
import '../../../domain/entities/store.dart';

Widget itemDetailsInfo(Store store, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Naziv objekta"),
        _buildLargerSectionContent(store.name),
        _buildDivider(context),
        _buildSectionTitle("Popusti"),
        _buildSectionContent(_formatList(store.discounts)),
        _buildDivider(context),
        _buildSectionTitle("Uslovi"),
        _buildSectionContent(_formatList(store.conditions)),
      ],
    ),
  );
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(title, style: AppTextStyles.titleBold),
  );
}

Widget _buildLargerSectionContent(String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(content, style: AppTextStyles.titleBold.copyWith(fontSize: 18.0)),
  );
}

Widget _buildSectionContent(String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(content),
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

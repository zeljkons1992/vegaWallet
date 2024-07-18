import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/size_const.dart';
import '../../../../core/ui/theme/text_style.dart';

class DiscountConditions extends StatefulWidget {
  final List<String> conditions;
  const DiscountConditions({super.key, required this.conditions});

  @override
  State<DiscountConditions> createState() => _DiscountConditionsState();
}

class _DiscountConditionsState extends State<DiscountConditions> {

  List<String> _uniqueElements(List<String> elements) {
    return elements.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final localization = AppLocalizations.of(context)!;
    final conditionsText = widget.conditions.isEmpty ? localization.defaultConditionsText : _uniqueElements(widget.conditions).join(', ');

    return TextField(
      decoration: InputDecoration(
        labelText: localization.discountCalculatorConditionsTitle,
        labelStyle: AppTextStyles(context).searchBarText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_TINY),
          borderSide: BorderSide(color: colorScheme.onSurface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_TINY),
          borderSide: BorderSide(color: colorScheme.onSurface),
        ),
      ),
      controller: TextEditingController(
        text: conditionsText
      ),
      readOnly: true,
      maxLines: null,
    );
  }
}

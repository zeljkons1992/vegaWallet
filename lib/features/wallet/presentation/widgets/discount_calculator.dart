import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegawallet/core/constants/size_const.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscountCalculator extends StatefulWidget {
  final Store store;

  const DiscountCalculator({super.key, required this.store});

  @override
  DiscountCalculatorState createState() => DiscountCalculatorState();
}

class DiscountCalculatorState extends State<DiscountCalculator> {
  final TextEditingController _priceController = TextEditingController();
  double? _discountedPrice;

  List<String> _uniqueElements(List<String> elements) {
    return elements.toSet().toList();
  }

  void _calculateDiscount() {
    final price = double.tryParse(_priceController.text);
    if (price != null && widget.store.parsedDiscount != null) {
      setState(() {
        _discountedPrice = price - (price * widget.store.parsedDiscount! / 100);
      });
    } else {
      setState(() {
        _discountedPrice = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final uniqueConditions = _uniqueElements(widget.store.conditions);

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: PADDING_VALUE_LARGE),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_TINY),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(PADDING_VALUE_SMALL),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _priceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      labelText: t.discountCalculatorHint,
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      _calculateDiscount();
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _priceController.clear();
                                    setState(() {
                                      _discountedPrice = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: SIZED_BOX_LARGE),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.discountCalculatorResultLabel,
                          style: AppTextStyles.titleBold,
                        ),
                        Text(
                          _discountedPrice != null
                              ? '${_discountedPrice!.toStringAsFixed(2)} rsd'
                              : t.discountCalculatorInvalidResult,
                          style: AppTextStyles.headline1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: PADDING_VALUE_LARGE),
              child:
              TextField(
                decoration: InputDecoration(
                  labelText: t.discountCalculatorConditionsTitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(CIRCULAR_BORDER_RADIUS_TINY),
                  ),
                ),
                controller: TextEditingController(
                  text: uniqueConditions.join(', '),
                ),
                readOnly: true,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

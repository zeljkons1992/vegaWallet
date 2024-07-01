import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

class DiscountCalculator extends StatefulWidget {
  final Store store;

  const DiscountCalculator({super.key, required this.store});

  @override
  DiscountCalculatorState createState() => DiscountCalculatorState();
}

class DiscountCalculatorState extends State<DiscountCalculator> {
  final TextEditingController _priceController = TextEditingController();
  double? _discountedPrice;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                labelText: "Price",
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
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price with discount:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _discountedPrice != null
                        ? '${_discountedPrice!.toStringAsFixed(2)} rsd'
                        : 'N/A',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

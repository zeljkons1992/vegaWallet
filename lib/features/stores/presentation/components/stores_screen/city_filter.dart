import 'package:flutter/material.dart';

class CityFilter extends StatelessWidget {
  final List<String> cities;
  final String? selectedCity;
  final ValueChanged<String?> onCitySelected;

  const CityFilter({
    Key? key,
    required this.cities,
    this.selectedCity,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get theme brightness to determine if we're in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Add "All" option as the first chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selectedCity == null,
              showCheckmark: false,
              onSelected: (selected) {
                onCitySelected(null);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              selectedColor: isDarkMode ? Colors.white : Colors.black,
              labelStyle: TextStyle(
                color: selectedCity == null
                    ? isDarkMode ? Colors.black : Colors.white
                    : null,
              ),
            ),
          ),
          ...cities.map((city) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(city),
                selected: selectedCity == city,
                showCheckmark: false,
                onSelected: (selected) {
                  onCitySelected(selected ? city : null);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                selectedColor: isDarkMode ? Colors.white : Colors.black,
                labelStyle: TextStyle(
                  color: selectedCity == city
                      ? isDarkMode ? Colors.black : Colors.white
                      : null,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
} 
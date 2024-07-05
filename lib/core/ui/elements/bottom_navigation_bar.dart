import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MyBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  MyBottomNavigationBarState createState() => MyBottomNavigationBarState();
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: colorScheme.onPrimary,
        indicatorColor: colorScheme.primary,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            color: Color(colorScheme.onSecondaryContainer.value),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimary);
          }
          return  IconThemeData(color:colorScheme.primary );
        }),
      ),
      child: NavigationBar(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: (index) {
          widget.onItemTapped(index);
        },
        destinations:  <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: t.walletTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.store_mall_directory_outlined),
            selectedIcon: const Icon(Icons.store_mall_directory),
            label: t.storesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: t.mapsTitle,
          ),
        ],
      ),
    );
  }
}

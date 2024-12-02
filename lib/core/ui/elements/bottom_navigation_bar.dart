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
    final localization = AppLocalizations.of(context)!;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.tertiaryFixed,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            color: Color(colorScheme.onSurface.value),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onTertiaryFixed);
          }
          return  IconThemeData(color: colorScheme.onSurface);
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
            label: localization.walletTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.store_mall_directory_outlined),
            selectedIcon: const Icon(Icons.store_mall_directory),
            label: localization.storesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: localization.mapsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_circle_outlined),
            selectedIcon: const Icon(Icons.account_circle_rounded),
            label: localization.profileTitle,
          ),
        ],
      ),
    );
  }
}
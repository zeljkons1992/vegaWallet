import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MyBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _MyBottomNavigationBar createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;


    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: colorScheme.onPrimary,
        indicatorColor: colorScheme.primary,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Color(-13157824),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimary);
          }
          return const IconThemeData(color: Color(-13157824));
        }),
      ),
      child: NavigationBar(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_mall_directory_outlined),
            selectedIcon: Icon(Icons.store_mall_directory),
            label: 'Stores',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
      ),
    );
  }
}

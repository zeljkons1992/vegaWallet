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
  MyBottomNavigationBarState createState() => MyBottomNavigationBarState();
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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

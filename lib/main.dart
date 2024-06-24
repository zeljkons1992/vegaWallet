import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/navigation/go_router.dart';
import 'package:vegawallet/core/ui/elements/bottom_navigation_bar.dart';

import 'core/ui/theme/theme.dart';
import 'core/ui/theme/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/stores');
        break;
      case 2:
        context.go('/maps');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

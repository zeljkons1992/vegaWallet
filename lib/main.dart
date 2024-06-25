import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/navigation/go_router.dart';
import 'package:vegawallet/core/ui/elements/bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/features/stores/presentation/screens/store_screen.dart';
import 'injection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/ui/theme/theme.dart';
import 'core/ui/theme/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

enum TabItem { home, stores, maps }

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  TabItem _selectedTab = TabItem.home;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = TabItem.values[index];
    });

    switch (_selectedTab) {
      case TabItem.home:
        context.go('/');
        break;
      case TabItem.stores:
        context.go('/stores');
        break;
      case TabItem.maps:
        context.go('/maps');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedTab.index,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

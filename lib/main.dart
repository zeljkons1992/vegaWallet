import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/constants/assets_const.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/navigation/go_router.dart';
import 'package:vegawallet/core/ui/elements/bottom_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/ui/theme/theme.dart';
import 'core/ui/theme/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await configureDependencies();
  await precacheInitialAssets();
  runApp(const MyApp());
}

precacheInitialAssets() async {
  await Future.wait([
    precacheSvgPicture(vegaCardBackside),
    precacheSvgPicture(vegaCard)
  ]);
}

Future precacheSvgPicture(String svgPath) async {
  final logo = SvgAssetLoader(svgPath);
  await svg.cache.putIfAbsent(logo.cacheKey(null), () => logo.loadBytes(null));
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

enum TabItem { home, stores, maps }

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  MainScreenState createState() => MainScreenState();
}
class MainScreenState extends State<MainScreen> {
  TabItem _selectedTab = TabItem.home;
  int _previousIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _selectedTab.index;
      _selectedTab = TabItem.values[index];
    });

    final isRightToLeft = _previousIndex < _selectedTab.index;

    switch (_selectedTab) {
      case TabItem.home:
        context.go('/', extra: isRightToLeft);
        break;
      case TabItem.stores:
        context.go('/stores', extra: isRightToLeft);
        break;
      case TabItem.maps:
        context.go('/maps', extra: isRightToLeft);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.child,
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedTab.index,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
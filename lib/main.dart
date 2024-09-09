import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/constants/assets_const.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/navigation/go_router.dart';
import 'package:vegawallet/core/ui/elements/bottom_navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc.dart';
import 'core/ui/theme/theme.dart';
import 'core/ui/theme/util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/localization/presentation/bloc/locale_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await configureDependencies();
  await precacheInitialAssets();
  runApp(const MyApp());
}

Future<void> precacheInitialAssets() async {
  await Future.wait([
    precacheSvgPicture(vegaCardBackside),
    precacheSvgPicture(vegaCard),
    precacheSvgPicture('assets/img/flag_of_serbia.svg'),
    precacheSvgPicture('assets/img/flag_of_uk.svg')
  ]);
}

Future<void> precacheSvgPicture(String svgPath) async {
  final logo = SvgAssetLoader(svgPath);
  await svg.cache.putIfAbsent(logo.cacheKey(null), () => logo.loadBytes(null));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          LocaleBloc()
            ..add(const GetInitialLocale()),
        ),
        BlocProvider(
          create: (context) => getIt<StoreBloc>()..add(LoadStores()),
        ),
      ],
      child: Builder(
          builder: (context) {
            return BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, state) {
                return MaterialApp.router(
                  locale: state.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'),
                    Locale('sr'),
                  ],
                  title: 'Flutter Demo',
                  theme: theme.light(),
                  darkTheme: theme.dark(),
                  themeMode: ThemeMode.system,
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          }
      ),
    );
  }
}
enum TabItem { home, stores, maps, profile }

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
      case TabItem.profile:
        context.go('/profile', extra: isRightToLeft);
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
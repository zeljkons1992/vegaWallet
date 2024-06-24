import 'package:go_router/go_router.dart';
import 'package:vegawallet/features/maps/presentaion/screens/map_screen.dart';
import 'package:vegawallet/features/stores/presentation/screens/stores_screen.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/presentation/screens/wallet_screen.dart';

import '../../main.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => WalletScreen(walletCardInformation: WalletCardInformation(name: "Nikola\nRanković",expiry: "12/25",cardNo: "100 951"),)
        ),
        GoRoute(
          path: '/stores',
          builder: (context, state) => StoresScreen(),
        ),
        GoRoute(
          path: '/maps',
          builder: (context, state) => MapsScreen(),
        ),
      ],
    ),
  ],
);

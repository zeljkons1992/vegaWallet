import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/features/auth/presentaion/components/verification_screen/verification_start.dart';
import 'package:vegawallet/features/auth/presentaion/screens/error_auth_screen.dart';
import 'package:vegawallet/features/maps/presentaion/screens/map_screen.dart';
import 'package:vegawallet/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vegawallet/features/profile/presentation/screens/profile_screen.dart';
import 'package:vegawallet/features/stores/presentation/screens/store_screen.dart';
import 'package:vegawallet/features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/auth/presentaion/screens/sign_in_screen.dart';
import '../../features/stores/domain/entities/store.dart';
import '../../features/stores/presentation/screens/stores_details_screen.dart';
import '../../main.dart';
import '../services/auth_services.dart';
import 'custom_transition_page_builder.dart';

final AuthService _authService = AuthService();

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = _authService.isUserLoggedIn();
    if (!isLoggedIn && state.name != '/login') {

      return '/login';
    }
    if (isLoggedIn && state.name == '/login') {
      return '/';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              customTransitionPage(context, state, const WalletScreen()),
        ),
        GoRoute(
          path: '/stores',
          pageBuilder: (context, state) =>
              customTransitionPage(context, state, const StoresScreen()),
          routes: [
            GoRoute(
              path: 'store_details',
              builder: (context, state) {
                final store = state.extra as Store;
                return StoreDetailsScreen(store: store);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/maps',
          pageBuilder: (context, state) =>
              customTransitionPage(context, state, const MapScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              customTransitionPage(context, state, const ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => SignInScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) => const ErrorAuthScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ErrorAuthScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/startVerification',
      builder: (context, state) => const VerificationStart(),
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const VerificationStart(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
  ],
);
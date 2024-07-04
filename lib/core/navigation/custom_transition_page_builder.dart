import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<dynamic> customTransitionPage(BuildContext context, GoRouterState state, Widget child) {
  final isRightToLeft = state.extra is bool ? state.extra as bool : true;

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = isRightToLeft ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 150),
  );
}



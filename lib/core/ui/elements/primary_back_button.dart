import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrimaryBackButton extends StatelessWidget {
  const PrimaryBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16.0,
      left: 16.0,
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          decoration:  BoxDecoration(
            color: Colors.black.withOpacity(0.3),

            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

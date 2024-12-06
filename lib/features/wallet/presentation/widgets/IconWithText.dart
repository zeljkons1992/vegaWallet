import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWithText extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const IconWithText({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: colorScheme.onSurface,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0), // Padding za razmak između ikonice i gornje ivice bordera
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8.0), // Razmak između slike i teksta
              Text(
                label, // Tekst ispod ikonice
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

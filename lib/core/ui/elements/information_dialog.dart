import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';

class InformationDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;

  const InformationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: colorScheme.surfaceBright),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles(context).headline2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTextStyles(context).bodyText2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: AppTextStyles(context).cardLabelTitle,
                  ),
                ),
              ),
              const SizedBox(width: 32.0),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';

class InformationDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final String? disclaimer;
  Color iconColor;
  final VoidCallback onPressOk;

  InformationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.onPressOk,
    required this.iconColor,
    this.disclaimer,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      }, // Prevent closing by tapping outside
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colorScheme.surface,
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: iconColor),
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
            const SizedBox(height: 8),
            disclaimer != null ? Text(
              disclaimer!,
              style: AppTextStyles(context).bodyText2,
              textAlign: TextAlign.center,
            ) : const SizedBox(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onPressOk(); // Call the callback function
                      Navigator.of(context).pop(); // Close the dialog
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileNotificationSection extends StatefulWidget {
  const ProfileNotificationSection({super.key});

  @override
  ProfileNotificationSectionState createState() => ProfileNotificationSectionState();
}

class ProfileNotificationSectionState extends State<ProfileNotificationSection> {
  bool isPushNotificationEnabled = false;
  bool isLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurface),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localization.notification, style: AppTextStyles(context).headline4),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.notification_add_outlined),
                  const SizedBox(width: 8),
                  Text(localization.pushNotifications, style: AppTextStyles(context).headline3),
                  const Spacer(),
                  Switch(
                    activeColor: Colors.black,
                    activeTrackColor: colorScheme.tertiaryFixed,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.black,
                    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent;
                      }
                      return colorScheme.onSurface;
                    }),
                    value: isPushNotificationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        isPushNotificationEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: colorScheme.onSurface,
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.location_history),
                  const SizedBox(width: 8),
                  Text(localization.enableLocation, style: AppTextStyles(context).headline3),
                  const Spacer(),
                  Switch(
                    activeColor: Colors.black,
                    activeTrackColor: colorScheme.tertiaryFixed,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.black,
                    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent;
                      }
                      return colorScheme.onSurface;
                    }),
                    value: isLocationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        isLocationEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

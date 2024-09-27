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

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
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
            const Divider(
              color: Colors.black12,
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

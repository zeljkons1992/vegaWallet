import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vegawallet/features/profile/domain/enums/location_permission_response.dart';
import 'package:vegawallet/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../../core/ui/elements/information_dialog.dart';
import '../../../domain/entites/user_profile_information.dart';

class ProfileNotificationSection extends StatefulWidget {
  final UserProfileInformation user;

  const ProfileNotificationSection({super.key, required this.user});

  @override
  ProfileNotificationSectionState createState() =>
      ProfileNotificationSectionState();
}

class ProfileNotificationSectionState
    extends State<ProfileNotificationSection> {
  bool _isPushNotificationEnabled = false;
  late ProfileBloc _profileBloc;
  late StreamSubscription<LocationPermissionResponse>
      _permissionStreamSubscription;
  late bool _isLocationTrackingSuccessful;

  @override
  void initState() {
    super.initState();
    _isLocationTrackingSuccessful = widget.user.isLocationOn!;
    _profileBloc = BlocProvider.of<ProfileBloc>(context)
      ..add(GetRemoteUserInformation());
    _permissionStreamSubscription = _profileBloc.locationPermissionStream
        .listen((locationPermissionResponse) {
      if (locationPermissionResponse == LocationPermissionResponse.notGranted || locationPermissionResponse == LocationPermissionResponse.serviceDisabled) {
        setState(() {
          _isLocationTrackingSuccessful = false;
        });
        showDialog(
          context: context,
          builder: (context) => InformationDialog(
            title: AppLocalizations.of(context)!.locationTrackingFailedTitle,
            description:
            AppLocalizations.of(context)!.locationTrackingFailedDescription,
            icon: Icons.warning_rounded,
            iconColor: Theme.of(context).colorScheme.error,
            buttonText: 'OK',
            onPressOk: () => {},
          ),
        );
      } else {
        setState(() {
          _isLocationTrackingSuccessful = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _permissionStreamSubscription.cancel();
  }

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
            Text(localization.notification,
                style: AppTextStyles(context).headline4),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.notification_add_outlined),
                  const SizedBox(width: 8),
                  Text(localization.pushNotifications,
                      style: AppTextStyles(context).headline3),
                  const Spacer(),
                  Switch(
                    value: _isPushNotificationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isPushNotificationEnabled = value;
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
                  Text(localization.enableLocation,
                      style: AppTextStyles(context).headline3),
                  const Spacer(),
                  Switch(
                    value: _isLocationTrackingSuccessful,
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          showDialog(
                            context: context,
                            builder: (context) => InformationDialog(
                              title: localization.locationTrackingEnabledTitle,
                              description:
                                  localization.locationTrackingEnabledDescription,
                              disclaimer:
                                  localization.locationTrackingEnabledDisclaimer,
                              icon: Icons.warning_rounded,
                              iconColor:
                                  Theme.of(context).colorScheme.surfaceBright,
                              buttonText: 'OK',
                              onPressOk: () =>
                                  _profileBloc.add(StartLocationTracking()),
                            ),
                          );
                        } else {
                          _isLocationTrackingSuccessful = false;
                          _profileBloc.add(StopLocationTracking());
                        }
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

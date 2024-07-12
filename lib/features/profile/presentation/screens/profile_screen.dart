import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/auth/presentaion/bloc/auth/auth_bloc.dart';
import 'package:vegawallet/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vegawallet/features/profile/presentation/components/profile/profile_notification_section.dart';
import '../../../../core/di/injection.dart';
import '../components/profile/profile_general_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProfileBloc>()..add(GetUserInformation()),
        ),
        BlocProvider(
          create: (context) => getIt<AuthBloc>(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              switch (state) {
                case AuthLogoutSuccess _:
                  return context.go("/login");
              }
            },
            builder: (context, state) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileInformationSuccess) {
                    final userProfileInformation = state.userProfileInformation;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                userProfileInformation.profileImage),
                          ),
                          Text(userProfileInformation.nameAndSurname,
                              style: AppTextStyles.headline1),
                          const SizedBox(height: 4),
                          Text(
                              "${localization.joined} ${state.userProfileInformation.dateTime}",
                              style: AppTextStyles.bodyText1),
                          profileGeneralSection(state.userProfileInformation),
                          const ProfileNotificationSection(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Builder(builder: (context) {
                                return ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(LogoutUser());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child:  Text(localization.logout,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProfileInformationError) {
                    return  Center(
                        child: Text(localization.failedToLoadProfileInfo));
                  } else {
                    return const Center(child: Text('Unknown state'));
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/auth/presentaion/bloc/auth/auth_bloc.dart';

import '../../../../core/constants/assets_const.dart';
import '../../../../core/di/injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/localization_helper.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authBloc = getIt<AuthBloc>();
  late StreamSubscription<bool> navigationStream;
  @override
  void initState() {
    super.initState();
    _startListeningToAuthStream();

  }
  
  _startListeningToAuthStream() {
    navigationStream = authBloc.streamNavigationSuccess.listen((event) {
      context.go('/');
    });
  }
  
  @override
  void dispose() {
    navigationStream.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          switch(state){
            case AuthLoginWithGoogleError _:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(translate(state.message, localization)),
                  duration: const Duration(seconds: 3),
                ),
              );
            // case AuthLoginWithGoogleSuccess _:
            //   return context.go("/");

          }
        },
        builder: (context, state) {
          switch(state){
            case AuthVegaStartAuthorization _:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case AuthLoginWithGoogleSuccess _:
              return Scaffold(
                backgroundColor: colorScheme.surface,
              );
            default:
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          vegaWalletLogo,
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 40),
                        Builder(
                          builder: (context) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(LoginWithGoogle());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    googleIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Login with Google',
                                    style: AppTextStyles(context).headline2,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Powered by",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              vegaDarkLogo,
                              width: 70,
                              height: 24,
                              color: colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

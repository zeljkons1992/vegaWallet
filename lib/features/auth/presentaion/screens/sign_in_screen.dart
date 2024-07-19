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
import '../../../stores/presentation/bloc/store_bloc/store_bloc.dart';

class SignInScreen extends StatefulWidget {
  final StoreBloc _storeBloc = getIt<StoreBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late StreamSubscription<bool> _navigationStream;

  @override
  void initState() {
    super.initState();
    _startListeningToAuthStream();
  }

  void _startListeningToAuthStream() {
    _navigationStream = widget._authBloc.streamNavigationSuccess.listen((event) {
        widget._storeBloc.add(LoadStores());
        context.go('/');
    });
  }

  @override
  void dispose() {
    _navigationStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: widget._authBloc,
        ),
        BlocProvider.value(
          value: widget._storeBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginWithGoogleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(translate(state.message, localization)),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final authState = context.watch<AuthBloc>().state;
            final storeState = context.watch<StoreBloc>().state;
            if (authState is AuthVegaStartAuthorization ||
                storeState is StoreLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(LoginWithGoogle());
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
                              localization.loginWithGoogle,
                              style: AppTextStyles(context).headline2,
                            ),
                          ],
                        ),
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
          },
        ),
      ),
    );
  }
}

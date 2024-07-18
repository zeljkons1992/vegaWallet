import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/auth/presentaion/bloc/auth/auth_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc/store_bloc.dart';

import '../../../../core/constants/assets_const.dart';
import '../../../../core/di/injection.dart';

class SignInScreen extends StatelessWidget {
  final StoreBloc _storeBloc = getIt<StoreBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _authBloc,
        ),
        BlocProvider(
          create: (context) => _storeBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginWithGoogleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Login unsuccessful. The application is only for Vega employees."),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else if (state is AuthLoginWithGoogleSuccess) {
                _storeBloc.add(LoadStores());
              }
            },
          ),
          BlocListener<StoreBloc, StoreState>(
            listener: (context, state) {
              if (state is StoreLoaded) {
                context.go("/");
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
            } else if (authState is AuthLoginWithGoogleSuccess) {
              return Scaffold(
                backgroundColor: colorScheme.surface,
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

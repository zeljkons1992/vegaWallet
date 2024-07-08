import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/features/auth/presentaion/bloc/auth_bloc.dart';

import '../../../../core/di/injection.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch(state){
            case AuthLoginWithGoogleSuccess _:
              return context.replace("/");
            case AuthLoginWithGoogleError _:
              return context.go("??ASW@!!@DLDKS:L@");
            default:
              return context.go("location");
          }
        },
        child: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LoginWithGoogle());
                  }, child: const Icon(Icons.g_mobiledata_outlined),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

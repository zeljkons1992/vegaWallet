import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/features/auth/presentaion/components/verification_screen/verification_start.dart';

import '../bloc/auth/auth_bloc.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<AuthBloc>()..add(CheckIsUserVega()),
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous,current){
           return current is AuthVegaConfirm || current is AuthVegaNotConfirm;
          },
          listener: (context, state) {
            switch (state) {
              case AuthVegaConfirm _:
                return context.go("/");
              case AuthVegaNotConfirm _:
                return context.go("/login");
              default:
                return context.go("");
            }
          },
          builder: (context, state) {
            switch(state) {
              case AuthVegaStartAuthorization _:
                return verificationStart();
              case AuthVegaConfirmAnimation _:
                return const Text("JESTE VEGA POTVRDJEN IDENTITET");
              case AuthVegaNotConfirmAnimation _:
                return const Text("NIJE VEGA ACCOUNT");
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/features/auth/presentaion/components/verification_screen/verification_start.dart';
import 'package:vegawallet/features/auth/presentaion/components/verification_screen/verification_unsuccessful.dart';
import '../bloc/auth/auth_bloc.dart';
import '../components/verification_screen/verification_success.dart';

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
              case AuthVegaStartAuthorization _:
                return context.go("/verificationStart");
              default:
                return context.go("");
            }
          },
          buildWhen: (previous,current){
            return current is !AuthVegaConfirm && current is !AuthVegaNotConfirm;
          },
          builder: (context, state) {
            switch(state) {
              case AuthVegaStartAuthorization _:
                return const VerificationStart();
              case AuthVegaConfirmAnimation _:
                return  verificationSuccess(context);
              case AuthVegaNotConfirmAnimation _:
                return verificationUnsuccessful(context);
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}


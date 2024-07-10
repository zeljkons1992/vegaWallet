import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/di/injection.dart';

import '../../../auth/presentaion/bloc/auth/auth_bloc.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch(state){
            case AuthLogoutSuccess _:
              return context.replace("/login");
            case AuthLogoutError _:
              return context.go("??ASW@!!@DLDKS:L@");
            default:
              return context.go("location");
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () { throw Exception(); },
                child: const Text('Throw Exception'),
              ),
              Center(
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(LogoutUser());
                    }, child: const Icon(Icons.logout));
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

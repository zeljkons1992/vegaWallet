import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';

import '../../../../core/di/injection.dart';

class StoreScreen extends StatelessWidget {
   StoreScreen({super.key});

  final StoreBloc storeBloc = getIt<StoreBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoreBloc>(
      create: (context) => storeBloc..add(LoadStores()),
      child: Center(
        child: ElevatedButton(
          child: const Text("click"),
          onPressed: () {
            storeBloc.add(LoadStores());
          },
        ),
      ),
    );
  }
}

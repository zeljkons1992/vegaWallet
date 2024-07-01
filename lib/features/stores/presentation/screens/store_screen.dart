import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/store_bloc.dart';
import '../components/stores_screen/stores_list.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StoreBloc>()..add(LoadStores()),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Prodavnice",
                  style: AppTextStyles.headline1,
                ),
              ),
              Expanded(
                child: BlocBuilder<StoreBloc, StoreState>(
                  builder: (context, state) {
                    if (state is StoreLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StoreLoaded) {
                      return StoresList(stores: state.stores);
                    } else if (state is StoreError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text("Unknown state"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

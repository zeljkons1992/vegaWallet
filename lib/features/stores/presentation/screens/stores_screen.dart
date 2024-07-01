import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegawallet/core/di/injection.dart';
import 'package:vegawallet/core/ui/theme/text_style.dart';
import 'package:vegawallet/features/stores/presentation/bloc/stores_bloc.dart';

import '../components/stores_screen/stores_list.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StoresBloc>()..add(FetchStoreWithDiscount()),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Prodavnice",style: AppTextStyles.headline1,),
              ),
              Expanded(
                child: BlocBuilder<StoresBloc, StoresState>(
                  builder: (context, state) {
                    if (state is StoreStateLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StoreStateLoaded) {
                      return StoresList(stores: state.stores);
                    } else if (state is StoreStateError) {
                      return Center(child: Text(state.error));
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

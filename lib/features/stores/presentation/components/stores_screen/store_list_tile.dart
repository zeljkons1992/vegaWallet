import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/ui/theme/theme.dart';

import '../../../domain/entities/store.dart';
import '../../bloc/store_bloc/store_bloc.dart';

class StoreListTile extends StatelessWidget {
  final Store store;

  const StoreListTile({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: colorScheme.onPrimary,
        child: InkWell(
          onTap: () {
            context.go('/stores/store_details', extra: store);
          },
          splashColor: MaterialTheme.lightScheme().primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  child: Icon(
                    Icons.location_city_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    store.isFavorite ? BlocProvider.of<StoreBloc>(context).add(RemoveStoreFromFavorites(store)) : BlocProvider.of<StoreBloc>(context)
                        .add(AddStoreToFavorites(store));
                  },
                  icon: store.isFavorite
                      ? const Icon(Icons.star_outlined)
                      : const Icon(Icons.star_border_outlined),
                  splashColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

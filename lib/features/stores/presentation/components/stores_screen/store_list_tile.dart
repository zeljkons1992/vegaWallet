import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/ui/theme/theme.dart';
import '../../../domain/entities/store.dart';
import '../../bloc/favorites_bloc/favorites_bloc.dart';
import '../../bloc/store_bloc/store_bloc.dart';

class StoreListTile extends StatefulWidget {
  final Store store;

  const StoreListTile({super.key, required this.store});

  @override
  State<StoreListTile> createState() => _StoreListTileState();
}

class _StoreListTileState extends State<StoreListTile> {
  late Store updatedStore;

  @override
  Widget build(BuildContext context) {
    // Remove the setState here, as we're updating the state via BLoC and navigation
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: colorScheme.onPrimary,
        child: InkWell(
          onTap: () {
            // Navigate to the store details screen using context.push
            context.push<Store>(
              '/stores/store_details',
              extra: {'store': widget.store, 'source': 'store'},
            ).then((updatedStore) {
              // Check for updated store data and dispatch the event outside of the async function
              if (updatedStore != null) {
                BlocProvider.of<StoreBloc>(context).add(UpdateStore(updatedStore));
              }
            });
          },
          splashColor: MaterialTheme.lightScheme().primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Store icon
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

                // Store name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.store.name),
                    ],
                  ),
                ),

                // Favorite button with BlocBuilder
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  buildWhen: (previous, current) {
                    return previous != current && current is FavoritesLoaded;
                  },
                  builder: (context, state) {
                    bool isFavorite = widget.store.isFavorite;

                    if (state is FavoritesLoaded) {
                      if (state.favorites.isNotEmpty) {
                        final updatedStore = state.favorites.firstWhere(
                              (s) => s.id == widget.store.id,
                          orElse: () => widget.store,
                        );
                        isFavorite = updatedStore.isFavorite;
                      } else {
                        // If the favorites list is empty, fall back to widget.store.isFavorite
                        isFavorite = false;
                      }
                    }

                    return IconButton(
                      onPressed: () {
                        // Toggle favorite status and update via BLoC
                        if (isFavorite) {
                          BlocProvider.of<FavoritesBloc>(context).add(RemoveStoreFromFavorites(widget.store));
                        } else {
                          BlocProvider.of<FavoritesBloc>(context).add(AddStoreToFavorites(widget.store));
                        }
                        BlocProvider.of<StoreBloc>(context).add(
                          UpdateStore(widget.store.copyWith(isFavorite: !isFavorite)),
                        );
                      },
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                      ),
                      splashColor: Colors.transparent,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/constants/icon_const.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final storeBloc = BlocProvider.of<StoreBloc>(context);
            final updatedStore = await context.push<Store>(
              '/stores/store_details',
              extra: {'store': widget.store, 'source': 'store'},
            );
            if (updatedStore != null && mounted) {
              storeBloc.add(UpdateStore(updatedStore));
            }
          },

          splashColor: MaterialTheme.lightScheme().primaryContainer,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 8.0),
            child: Row(
              children: [
                // Store icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      categoryIcons[widget.store.category] ?? 'assets/icons/beauty_and_health_icon.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                      width: 20.0,
                      height: 20.0,
                    ),
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
                        color: Theme.of(context).colorScheme.onSurface,
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

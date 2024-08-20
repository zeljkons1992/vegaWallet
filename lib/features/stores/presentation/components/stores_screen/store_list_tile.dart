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
  @override
  Widget build(BuildContext context) {
    if(widget.store.name == "Pupin Lounge") print("POZVAO SE REBUILD PUPIN LOUNGA");
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: colorScheme.onPrimary,
        child: InkWell(
          onTap: () async {
            final updatedStore = await context.push<Store>('/stores/store_details', extra: widget.store);
            if (updatedStore != null && context.mounted) {
              print("OVO SE POZVALO");
              print("UPDATES STORE KOJI SAM DOBIO NAKON POPA");
              print(updatedStore.toString());
              BlocProvider.of<StoreBloc>(context).add(UpdateStore(updatedStore));
              BlocProvider.of<FavoritesBloc>(context).add(GetFavorites());
            }
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
                      Text(widget.store.name),
                    ],
                  ),
                ),
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    bool isFavorite = widget.store.isFavorite;

                    bool shouldShowStar = widget.store.isFavorite;

                    if (state is FavoritesLoaded) {
                      //ToDo Bug
                        //isFavorite = state.favorites.any((favStore) => favStore.id == widget.store.id);
                      final updatedStore = state.favorites.firstWhere(
                            (s) => s.id == widget.store.id,
                        orElse: () => widget.store,
                      );

                      isFavorite = updatedStore.isFavorite;
                    }

                    return IconButton(
                      onPressed: () {
                        print("IS FAVORITE JE $isFavorite");
                        if (isFavorite) {
                          BlocProvider.of<FavoritesBloc>(context).add(RemoveStoreFromFavorites(widget.store));
                        } else {
                          BlocProvider.of<FavoritesBloc>(context).add(AddStoreToFavorites(widget.store));
                        }
                        BlocProvider.of<StoreBloc>(context).add(UpdateStore(widget.store.copyWith(isFavorite: !isFavorite)));
                      },
                      icon: Icon(
                        shouldShowStar ? Icons.star_outlined : Icons.star_border_outlined,
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

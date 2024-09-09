import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import '../../../../core/constants/size_const.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/ui/elements/primary_back_button.dart';
import '../../../../core/ui/elements/primary_dropdown_button.dart';
import '../../../../core/utils/intent_utils.dart';
import '../../domain/entities/address_city.dart';
import '../../domain/entities/store.dart';
import '../bloc/location_bloc/location_bloc.dart';
import '../components/details_screen/item_details_info.dart';
import '../components/details_screen/maps/map_location_error.dart';
import '../components/details_screen/maps/map_location_initail.dart';
import '../components/details_screen/maps/map_location_loaded.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/details_screen/maps/maps_unsuccessfully.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;

  const StoreDetailsScreen({super.key, required this.store});

  @override
  StoreDetailsScreenState createState() => StoreDetailsScreenState();
}

class StoreDetailsScreenState extends State<StoreDetailsScreen> {
  late StreamSubscription<DataState> _navigationStream;
  late LocationBloc _locationBloc;
  late FavoritesBloc _favoritesBloc;

  AddressCity? selectedDropdownItem;
  bool isStore = false;
  bool isMapExpanded = false;
  bool isMyCurrentLocationActive = false;
  double zoomLevel = 18.0;
  String? addressCity;

  late Store updatedStore;

  @override
  void initState() {
    super.initState();
    _locationBloc = getIt<LocationBloc>();
    _favoritesBloc = getIt<FavoritesBloc>();
    updatedStore = widget.store;
    if (widget.store.addressCities.isNotEmpty) {
      selectedDropdownItem = widget.store.addressCities.first;
    }
    _startListeningToMapStream();
  }

  void _startListeningToMapStream() {
    _navigationStream = _locationBloc.navigationStream.listen((event) {
      IntentUtils.launchMaps(event.data!.latitude, event.data!.longitude);
    });
  }

  @override
  void dispose() {
    _navigationStream.cancel();
    super.dispose();
  }

  void _expandMapAndShowLocations() {
    setState(() {
      isMapExpanded = !isMapExpanded;
      zoomLevel = isMapExpanded ? 16.0 : 18.0;
      isMyCurrentLocationActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (selectedDropdownItem != null) {
      addressCity =
          "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}";
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              _locationBloc..add(UpdateStoreLocation(addressCity ?? '')),
        ),

        BlocProvider(
          create: (context) => _favoritesBloc..add(GetFavorites()),
        )
      ],
      child: Scaffold(
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: isMapExpanded
                  ? MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      SIZE_OF_BOTTOM_NAVIGATION_BAR
                  : MediaQuery.of(context).size.height / 3,
              child: Stack(
                children: [
                  BlocConsumer<LocationBloc, LocationState>(
                    listener: (context, state) {
                      switch (state) {
                        case OpenNavigationToAddressUnsuccessful _:
                          Fluttertoast.showToast(
                            msg: localization.noFindAddress,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                      }
                    },
                    buildWhen: (previousState, currentState) {
                      if (currentState
                          is OpenNavigationToAddressUnsuccessful) {
                        return false;
                      }
                      return true;
                    },
                    builder: (context, state) {
                      switch (state) {
                        case LocationInitial _:
                          return mapLocationInitial(context);
                        case FetchStoreLocationSuccessState _:
                          return MapLocationLoadedWidget(
                            shouldCenter: isMyCurrentLocationActive,
                            latitude: state.position.latitude,
                            longitude: state.position.longitude,
                            zoomLevel: zoomLevel,
                          );
                        case FetchStoreLocationUnsuccessfullyState _:
                          return const MapsUnsuccessfully();
                        case LocationLoading _:
                          return const Center(
                              child: CircularProgressIndicator());
                        case NoInternetConnectionState _:
                          return const MapLocationError();
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                  PrimaryBackButton(
                    onBackPressed: () {
                      //context.push("/stores", extra: updatedStore);
                      context.push("/stores");
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: IconButton(
                        onPressed: () => _expandMapAndShowLocations(),
                        icon: Icon(
                          isMapExpanded
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isMapExpanded)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        color: colorScheme.surfaceBright,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) {
                                return PrimaryDropdownButton(
                                  items: widget.store.addressCities,
                                  selectedItem: selectedDropdownItem,
                                  onChanged: (value) async {
                                    setState(() {
                                      selectedDropdownItem = value;
                                    });

                                    if (selectedDropdownItem != null) {
                                      String addressCity =
                                          "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}";
                                      BlocProvider.of<LocationBloc>(context)
                                          .add(UpdateStoreLocation(
                                              addressCity));
                                    }
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary,
                              ),
                              child: Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    BlocProvider.of<LocationBloc>(context)
                                        .add(
                                      OpenNavigationToAddress(
                                          "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}"),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.directions,
                                  ),
                                  color: Colors.white,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      ItemDetailsInfo(
                        store: widget.store,
                        onUpdate: (Store updated) {
                          setState(() {
                            updatedStore = updated;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

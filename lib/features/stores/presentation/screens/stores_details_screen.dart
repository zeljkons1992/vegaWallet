import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/stores/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import '../../../../core/constants/size_const.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/ui/elements/primary_back_button.dart';
import '../../../../core/ui/elements/primary_dropdown_button.dart';
import '../../../../core/utils/intent_utils.dart';
import '../../../wallet/presentation/widgets/discount_calculator.dart';
import '../../../wallet/presentation/widgets/discount_info.dart';
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
  final String source;

  const StoreDetailsScreen({super.key, required this.store, required this.source});

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
    if (_favoritesBloc.state is! FavoritesLoaded) {
      _favoritesBloc.add(GetFavorites());
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
      addressCity = "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}";
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _locationBloc..add(UpdateStoreLocation(addressCity ?? '')),
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop,Object? result)async {
          if (widget.source == "search") {
            context.pushReplacement('/stores', extra: updatedStore);
          } else {
            context.pop(updatedStore);
          }
        },
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
                        if (state is OpenNavigationToAddressUnsuccessful) {
                          Fluttertoast.showToast(
                            msg: localization.noFindAddress,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      buildWhen: (previousState, currentState) {
                        return currentState is! OpenNavigationToAddressUnsuccessful;
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
                            return const Center(child: CircularProgressIndicator());
                          case NoInternetConnectionState _:
                            return const MapLocationError();
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                    PrimaryBackButton(
                      onBackPressed: () {
                        if (widget.source == "search") {
                          context.pushReplacement('/stores', extra: updatedStore);
                        } else {
                          context.pop(updatedStore);
                        }
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
                            isMapExpanded ? Icons.fullscreen_exit : Icons.fullscreen,
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
                          color: colorScheme.surface,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                        String addressCity = "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}";
                                        BlocProvider.of<LocationBloc>(context).add(UpdateStoreLocation(addressCity));
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 1),
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: Builder(
                                  builder: (context) {
                                    return IconButton(
                                      onPressed: () {
                                        BlocProvider.of<LocationBloc>(context).add(
                                            OpenNavigationToAddress("${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}")
                                        );
                                      },
                                        icon: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                        color: const Color(0xFFFF9211),
                                        borderRadius: BorderRadius.circular(8.0),
                                        ),
                                          child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SvgPicture.asset(
                                          'assets/icons/navigation_arrow_icon.svg',
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(context).colorScheme.onSurface,
                                                BlendMode.srcIn,
                                              ),
                                        ),
                                      ),
                                    ),
                                    );
                                  }
                                ),
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
                        const SizedBox(height: 20),
                        widget.store.parsedDiscount != null
                            ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DiscountCalculator(store: widget.store),
                            )
                            : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DiscountInfo(store: widget.store),
                            ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

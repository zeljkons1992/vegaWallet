import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class StoreDetailsScreen extends StatefulWidget {
  final Store store;

  const StoreDetailsScreen({super.key, required this.store});

  @override
  StoreDetailsScreenState createState() => StoreDetailsScreenState();
}

class StoreDetailsScreenState extends State<StoreDetailsScreen> {
  AddressCity? selectedDropdownItem;
  bool isStore = false;
  bool isMapExpanded = false;
  double zoomLevel = 18.0;

  @override
  void initState() {
    super.initState();

    if (widget.store.addressCities.isNotEmpty) {
      selectedDropdownItem = widget.store.addressCities.first;
    }
  }

  void _expandMapAndShowLocations(BuildContext context) {
    setState(() {
      isMapExpanded = !isMapExpanded;
      if (isMapExpanded) {
        setState(() {
          zoomLevel = 16.0;
        });
      } else {
        setState(() {
          zoomLevel = 18.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => getIt<LocationBloc>()..add(GetLocation()),
      child: Scaffold(
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: isMapExpanded
                  ? MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 70
                  : MediaQuery.of(context).size.height / 3,
              child: Stack(
                children: [
                  BlocConsumer<LocationBloc, LocationState>(
                    listener: (context, state) {
                      if (state is OpenNavigationToAddressSuccessful) {
                        IntentUtils.launchMaps(
                            state.position.latitude, state.position.longitude);
                      } else if (state is OpenNavigationToAddressUnsuccessful) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nije dobro')),
                        );
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          if (state is LocationInitial) {
                            return mapLocationInitial(context);
                          } else if (state is LocationLoaded) {
                            return MapLocationLoadedWidget(
                              latitude: state.position.latitude,
                              longitude: state.position.longitude,
                              isStore: isStore,
                              zoomLevel: zoomLevel,
                            );
                          } else if (state is LocationLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is StoreLocationUpdatedSuccess) {
                            return MapLocationLoadedWidget(
                              latitude: state.position.latitude,
                              longitude: state.position.longitude,
                              isStore: isStore,
                              zoomLevel: zoomLevel,
                            );
                          } else {
                            return const MapLocationError();
                          }
                        },
                      );
                    },
                  ),
                  const PrimaryBackButton(),
                  Positioned(
                    right: 16,
                    top: MediaQuery.of(context).padding.top + 16.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Builder(builder: (context) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              isStore = false;
                            });
                            BlocProvider.of<LocationBloc>(context)
                                .add(GetLocation());
                          },
                          icon: const Icon(Icons.my_location),
                          color: Colors.white,
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () => _expandMapAndShowLocations(context),
                              icon: Icon(
                                isMapExpanded
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: Colors.white,
                              ),
                            );
                          }
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
                                      setState(() {
                                        isStore = true;
                                      });
                                      BlocProvider.of<LocationBloc>(context)
                                          .add(UpdateStoreLocation(addressCity));
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
                                    BlocProvider.of<LocationBloc>(context).add(
                                        OpenNavigationToAddress(
                                            "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}"));
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
                      itemDetailsInfo(widget.store, context),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/ui/elements/primary_back_button.dart';
import '../../../../core/ui/elements/primary_dropdown_button.dart';
import '../../../../core/utils/IntentUtils.dart';
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
  double? storeLatitude;
  double? storeLongitude;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.store.addressCities.isNotEmpty) {
      selectedDropdownItem = widget.store.addressCities.first;
      _setLocationFromAddress("${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}");
    }
  }

  Future<void> _setLocationFromAddress(String addressCity) async {
    List<Location> locations = await locationFromAddress(addressCity);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      setState(() {
        storeLatitude = location.latitude;
        storeLongitude = location.longitude;
        _mapController.move(LatLng(storeLatitude!, storeLongitude!), 18);
      });
      print('Address: $addressCity');
      print('Latitude: ${location.latitude}, Longitude: ${location.longitude}');
    } else {
      print('No location found for address: $addressCity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LocationBloc>()..add(GetLocation()),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                      switch (state) {
                        case LocationInitial _:
                          return mapLocationInitial(context);
                        case LocationLoaded _:
                          return MapLocationLoadedWidget(
                            initialLatitude: state.position.latitude,
                            initialLongitude: state.position.longitude,
                            storeLatitude: storeLatitude,
                            storeLongitude: storeLongitude,
                            mapController: _mapController,
                          );
                        case LocationLoading _:
                          return const CircularProgressIndicator();
                        default:
                          return const MapLocationError();
                      }
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
                      child: Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              BlocProvider.of<LocationBloc>(context).add(GetLocation());
                            },
                            icon: const Icon(Icons.my_location),
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          PrimaryDropdownButton(
                            items: widget.store.addressCities,
                            selectedItem: selectedDropdownItem,
                            onChanged: (value) async {
                              setState(() {
                                selectedDropdownItem = value;
                              });

                              if (selectedDropdownItem != null) {
                                String addressCity = "${selectedDropdownItem!.address}, ${selectedDropdownItem!.city}";
                                _setLocationFromAddress(addressCity);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (storeLatitude != null && storeLongitude != null) {
                                  IntentUtils.launchMaps(storeLatitude!, storeLongitude!);
                                } else {
                                  // Handle the case where the location is not set
                                }
                              },
                              icon: const Icon(
                                Icons.directions,
                              ),
                              color: Colors.white,
                            ),
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

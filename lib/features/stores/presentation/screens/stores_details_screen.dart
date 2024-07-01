import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vegawallet/core/ui/elements/primary_back_button.dart';
import 'package:vegawallet/features/stores/presentation/components/details_screen/item_details_info.dart';
import '../../../../core/ui/elements/primary_dropdown_button.dart';
import '../../domain/entities/address_city.dart';
import '../../domain/entities/store.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;

  const StoreDetailsScreen({super.key, required this.store});

  @override
  StoreDetailsScreenState createState() => StoreDetailsScreenState();
}

class StoreDetailsScreenState extends State<StoreDetailsScreen> {
  AddressCity? selectedDropdownItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(45.2671, 19.8335),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                  ],
                ),
                const PrimaryBackButton(),
                Positioned(
                    right: 16,
                    top: MediaQuery.of(context).padding.top + 16.0,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.3)),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.my_location),
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            flex: 2,
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
                        onChanged: (value) {
                          setState(() {
                            selectedDropdownItem = value;
                          });
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.directions,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                itemDetailsInfo(widget.store, context)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

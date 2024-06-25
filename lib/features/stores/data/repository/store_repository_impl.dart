import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../../domain/entities/address_city.dart';
import '../data_sources/api_client.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl implements StoreRepository {
  final ApiClient apiClient;

  StoreRepositoryImpl({required this.apiClient});

  @override
  Future<List<Store>> fetchStores() async {
    try {
      final response = await apiClient.downloadExcelFile('xlsx', '1pkLx5AoPiULXUxB-ZbQIKyiGpqt_TspXy0xENkvgeNo');
      print('Fetched response: ${response.response.statusCode}');

      if (response.response.statusCode == 200) {
        Uint8List bytes = Uint8List.fromList(response.data);
        print('Fetched bytes length: ${bytes.length}');
        SpreadsheetDecoder decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
        List<Store> stores = [];

        for (var table in decoder.tables.keys) {
          var sheet = decoder.tables[table];
          print('Decoded table: $table');

          String? currentName;
          List<AddressCity> currentAddressCities = [];
          List<String> currentDiscounts = [];
          List<String> currentConditions = [];

          String? lastCity;
          String? lastDiscount;
          String? lastCondition;

          for (var row in sheet!.rows.skip(1)) {
            if (row[1] != null && row[1].toString().isNotEmpty) {
              if (currentName != null) {
                stores.add(Store.withData(
                  name: currentName,
                  addressCities: currentAddressCities,
                  discounts: currentDiscounts,
                  conditions: currentConditions,
                  category: table,
                ));
              }

              currentName = row[1].toString();
              currentAddressCities = [];
              currentDiscounts = [];
              currentConditions = [];
            }

            String? address = row[2]?.toString();
            String? city = row[3]?.toString();
            String? discount = row[4]?.toString();
            String? condition = row[5]?.toString();

            if (city != null && city.isNotEmpty) {
              lastCity = city;
            }
            if (discount != null && discount.isNotEmpty) {
              lastDiscount = discount;
            }
            if (condition != null && condition.isNotEmpty) {
              lastCondition = condition;
            }

            if (address != null && address.isNotEmpty) {
              currentAddressCities.add(AddressCity.withData(
                address: address,
                city: lastCity ?? '',
              ));
            } else if (currentAddressCities.isEmpty && lastCity != null) {
              currentAddressCities.add(AddressCity.withData(
                address: '',
                city: lastCity,
              ));
            }
            if (lastDiscount != null && lastDiscount.isNotEmpty && currentDiscounts.isEmpty) {
              currentDiscounts.add(lastDiscount);
            }
            if (lastCondition != null && lastCondition.isNotEmpty && currentConditions.isEmpty) {
              currentConditions.add(lastCondition);
            }
          }

          if (currentName != null) {
            stores.add(Store.withData(
              name: currentName,
              addressCities: currentAddressCities,
              discounts: currentDiscounts,
              conditions: currentConditions,
              category: table,
            ));
          }
        }

        for (var store in stores) {
          print(store);
        }

        return stores;
      } else {
        print('Failed to fetch Excel file: ${response.response.statusCode}');
        throw Exception('Failed to fetch Excel file');
      }
    } catch (e) {
      print('Error fetching and decoding spreadsheet: $e');
      throw Exception('Failed to load data');
    }
  }
}

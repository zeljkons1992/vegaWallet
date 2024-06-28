import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import '../entities/address_city.dart';

@LazySingleton()
class ExcelMapper {
  List<Store> mapTablesToStores(Map<String, List<List<dynamic>>> tables) {
    final stores = <Store>[];

    for (var table in tables.keys) {
      var rows = tables[table]!;
      _mapTableToStores(rows, table, stores);
    }

    return stores;
  }

  void _mapTableToStores(List<List<dynamic>> rows, String category, List<Store> stores) {
    String? currentName;
    List<AddressCity> currentAddressCities = [];
    List<String> currentDiscounts = [];
    List<String> currentConditions = [];

    String? lastCity;
    String? lastDiscount;
    String? lastCondition;

    for (var row in rows.skip(1)) {
      if (row[1] != null && row[1].toString().isNotEmpty) {
        _addStoreIfExists(currentName, currentAddressCities, currentDiscounts, currentConditions, category, stores);

        currentName = row[1].toString();
        _resetCurrentStoreData(currentAddressCities, currentDiscounts, currentConditions);
      }

      lastCity = _updateLastValue(row[3]?.toString(), lastCity);
      lastDiscount = _updateLastValue(row[4]?.toString(), lastDiscount);
      lastCondition = _updateLastValue(row[5]?.toString(), lastCondition);

      _updateCurrentStoreData(row[2]?.toString(), lastCity, lastDiscount, lastCondition, currentAddressCities, currentDiscounts, currentConditions);
    }

    _addStoreIfExists(currentName, currentAddressCities, currentDiscounts, currentConditions, category, stores);
  }

  void _addStoreIfExists(
      String? currentName,
      List<AddressCity> currentAddressCities,
      List<String> currentDiscounts,
      List<String> currentConditions,
      String category,
      List<Store> stores,
      ) {
    if (currentName != null) {
      stores.add(Store.withData(
        name: currentName,
        addressCities: List.from(currentAddressCities),
        discounts: List.from(currentDiscounts),
        conditions: List.from(currentConditions),
        category: category,
      ));
    }
  }

  void _resetCurrentStoreData(
      List<AddressCity> currentAddressCities,
      List<String> currentDiscounts,
      List<String> currentConditions,
      ) {
    currentAddressCities.clear();
    currentDiscounts.clear();
    currentConditions.clear();
  }

  String? _updateLastValue(String? newValue, String? lastValue) {
    return (newValue != null && newValue.isNotEmpty) ? newValue : lastValue;
  }

  void _updateCurrentStoreData(
      String? address,
      String? lastCity,
      String? lastDiscount,
      String? lastCondition,
      List<AddressCity> currentAddressCities,
      List<String> currentDiscounts,
      List<String> currentConditions,
      ) {
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
    if (lastDiscount != null && lastDiscount.isNotEmpty) {
      currentDiscounts.add(lastDiscount);
    }
    if (lastCondition != null && lastCondition.isNotEmpty) {
      currentConditions.add(lastCondition);
    }
  }
}

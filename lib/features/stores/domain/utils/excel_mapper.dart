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
    double? parsedDiscount;

    String? lastCity;
    String? lastAddress;
    String? lastDiscount;

    for (var row in rows.skip(1)) {
      final rowData = _getRowData(row, rows[0]);

      if (rowData['name'] != null && rowData['name']!.isNotEmpty) {
        parsedDiscount = _calculateParsedDiscount(currentDiscounts);
        _addStoreIfExists(currentName, currentAddressCities, currentDiscounts, currentConditions, parsedDiscount, category, stores);

        currentName = rowData['name'];
        _resetCurrentStoreData(currentAddressCities, currentDiscounts, currentConditions);
      }

      lastCity = _updateLastValue(rowData['city'], lastCity);
      lastAddress = _updateLastValue(rowData['address'], lastAddress);
      lastDiscount = _updateLastValue(rowData['discount'], lastDiscount);

      _updateCurrentStoreData(rowData['address'], lastCity, lastDiscount, rowData['condition'], currentAddressCities, currentDiscounts, currentConditions);
    }

    parsedDiscount = _calculateParsedDiscount(currentDiscounts);
    _addStoreIfExists(currentName, currentAddressCities, currentDiscounts, currentConditions, parsedDiscount, category, stores);
  }

  Map<String, String?> _getRowData(List<dynamic> row, List<dynamic> header) {
    final rowData = <String, String?>{};

    for (var i = 0; i < row.length; i++) {
      final columnName = header[i]?.toString().toLowerCase().trim();
      final cellValue = row[i]?.toString().trim();

      if (columnName == null || cellValue == null) continue;

      switch (columnName) {
        case 'naziv objekta':
        case 'naziv partnera':
          rowData['name'] = cellValue;
          break;
        case 'grad':
          rowData['city'] = cellValue;
          break;
        case 'adresa':
          rowData['address'] = cellValue;
          break;
        case 'popust':
          rowData['discount'] = cellValue;
          break;
        case 'uslovi':
        case 'posebni uslovi':
          rowData['condition'] = cellValue;
          break;
      }
    }

    return rowData;
  }

  void _addStoreIfExists(
      String? currentName,
      List<AddressCity> currentAddressCities,
      List<String> currentDiscounts,
      List<String> currentConditions,
      double? parsedDiscount,
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
        parsedDiscount: parsedDiscount,
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
      String? condition,
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
    if (condition != null && condition.isNotEmpty) {
      currentConditions.add(condition);
    }
  }

  double? _calculateParsedDiscount(List<String> discounts) {
    final percentageRegex = RegExp(r'(\d+(\.\d+)?)\s*%');
    final decimalRegex = RegExp(r'^0\.\d+$');
    double? parsedDiscount;
    bool allMatch = true;
    Set<double> foundDiscounts = {};

    for (var discount in discounts) {
      final percentageMatch = percentageRegex.allMatches(discount);
      if (percentageMatch.isNotEmpty) {
        for (var match in percentageMatch) {
          final discountValue = double.parse(match.group(1)!);
          foundDiscounts.add(discountValue);
        }
      } else if (decimalRegex.hasMatch(discount)) {
        final discountValue = double.parse(discount) * 100;
        foundDiscounts.add(discountValue);
      } else {
        allMatch = false;
        break;
      }
    }

    if (foundDiscounts.length == 1) {
      parsedDiscount = foundDiscounts.first;
    } else {
      parsedDiscount = null;
    }

    return allMatch ? parsedDiscount : null;
  }
}

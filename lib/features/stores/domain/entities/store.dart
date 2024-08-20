import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'address_city.dart';
import 'address_location.dart';

part 'store.g.dart';

@Collection()
class Store {
  Id id = Isar.autoIncrement;
  late String name;
  late List<AddressCity> addressCities;
  late List<String> discounts;
  late List<String> conditions;
  late String category;
  late double? parsedDiscount;
  late bool isFavorite = false;

  Store();

  Store.withData({
    required this.name,
    required this.addressCities,
    required this.discounts,
    required this.conditions,
    required this.category,
    this.parsedDiscount,
    this.isFavorite = false,
  });

  Store copyWith({
    Id? id,
    String? name,
    List<AddressCity>? addressCities,
    List<String>? discounts,
    List<String>? conditions,
    String? category,
    double? parsedDiscount,
    bool? isFavorite,
  }) {
    return Store.withData(
      name: name ?? this.name,
      addressCities: addressCities ?? this.addressCities,
      discounts: discounts ?? this.discounts,
      conditions: conditions ?? this.conditions,
      category: category ?? this.category,
      parsedDiscount: parsedDiscount ?? this.parsedDiscount,
      isFavorite: isFavorite ?? this.isFavorite,
    )..id = id ?? this.id;
  }

  factory Store.fromMap(String name, List<List<dynamic>> rows,
      String category, double parsedDiscount) {
    return Store.withData(
      name: name,
      addressCities: _parseAddressCities(rows),
      discounts: _parseList(rows, 4),
      conditions: _parseList(rows, 5),
      category: category,
      parsedDiscount: parsedDiscount,
      isFavorite: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'addressCities': addressCities.map((addressCity) => addressCity.toMap()).toList(),
      'discounts': discounts,
      'conditions': conditions,
      'category': category,
      'parsedDiscount': parsedDiscount,
      'isFavorite': isFavorite,
    };
  }

  static List<AddressCity> _parseAddressCities(List<List<dynamic>> rows) {
    List<AddressCity> addressCities = [];
    for (var row in rows) {
      String? address = row[2]?.toString();
      String? city = row[3]?.toString();
      if (address != null && address.isNotEmpty && city != null &&
          city.isNotEmpty) {
        addressCities.add(AddressCity.withData(address: address, city: city));
      }
    }
    return addressCities;
  }

  static List<String> _parseList(List<List<dynamic>> rows, int index) {
    return rows.map((row) {
      return row[index]?.toString() ?? '';
    }).where((value) => value.isNotEmpty).toList();
  }

  @override
  String toString() {
    return 'Store {\n'
        '  id: $id,\n'
        '  name: $name,\n'
        '  addressCities: $addressCities,\n'
        '  discounts: $discounts,\n'
        '  conditions: $conditions,\n'
        '  category: $category\n'
        '  parsedDiscount: $parsedDiscount\n'
        '  isFavorite: $isFavorite\n'
        '}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Store &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              const DeepCollectionEquality().equals(addressCities, other.addressCities) &&
              const DeepCollectionEquality().equals(discounts, other.discounts) &&
              const DeepCollectionEquality().equals(conditions, other.conditions) &&
              category == other.category &&
              parsedDiscount == other.parsedDiscount &&
              isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      const DeepCollectionEquality().hash(addressCities) ^
      const DeepCollectionEquality().hash(discounts) ^
      const DeepCollectionEquality().hash(conditions) ^
      category.hashCode ^
      parsedDiscount.hashCode ^
      isFavorite.hashCode;

}

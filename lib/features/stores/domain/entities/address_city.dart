import 'package:isar/isar.dart';

part 'address_city.g.dart';

@embedded
class AddressCity {
  late String address;
  late String city;

  AddressCity();

  AddressCity.withData({
    required this.address,
    required this.city,
  });

  @override
  String toString() {
    return '{address: $address, city: $city}';
  }

  factory AddressCity.fromMap(Map<String, dynamic> map) {
    return AddressCity.withData(
      address: map['address'] as String,
      city: map['city'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
    };
  }

  static List<AddressCity> fromList(List<dynamic> list) {
    return list.map((item) => AddressCity.fromMap(item)).toList();
  }

  static List<Map<String, dynamic>> toList(List<AddressCity> list) {
    return list.map((item) => item.toMap()).toList();
  }
  AddressCity copyWith({String? address, String? city}) {
    return AddressCity()
      ..address = address ?? this.address
      ..city = city ?? this.city;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AddressCity &&
              runtimeType == other.runtimeType &&
              address == other.address &&
              city == other.city;

  @override
  int get hashCode => address.hashCode ^ city.hashCode;
}

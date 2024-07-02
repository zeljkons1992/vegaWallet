import 'package:isar/isar.dart';
import 'address_location.dart';

part 'address_city.g.dart';

@embedded
class AddressCity {
  late String address;
  late String city;
  AddressLocation? location;

  AddressCity();

  AddressCity.withData({
    required this.address,
    required this.city,
    this.location,
  });

  @override
  String toString() {
    return '{address: $address, city: $city, location: $location}';
  }

  factory AddressCity.fromMap(Map<String, dynamic> map) {
    return AddressCity.withData(
      address: map['address'] as String,
      city: map['city'] as String,
      location: map['location'] != null ? AddressLocation.fromMap(map['location']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'location': location?.toMap(),
    };
  }

  static List<AddressCity> fromList(List<dynamic> list) {
    return list.map((item) => AddressCity.fromMap(item)).toList();
  }

  static List<Map<String, dynamic>> toList(List<AddressCity> list) {
    return list.map((item) => item.toMap()).toList();
  }

  AddressCity copyWith({String? address, String? city, AddressLocation? location}) {
    return AddressCity()
      ..address = address ?? this.address
      ..city = city ?? this.city
      ..location = location ?? this.location;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AddressCity &&
              runtimeType == other.runtimeType &&
              address == other.address &&
              city == other.city &&
              location == other.location;

  @override
  int get hashCode => address.hashCode ^ city.hashCode ^ location.hashCode;
}

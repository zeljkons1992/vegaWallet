import 'package:isar/isar.dart';

part 'address_location.g.dart';

@embedded
class AddressLocation {
  late double latitude;
  late double longitude;

  AddressLocation();

  AddressLocation.withData({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return '{latitude: $latitude, longitude: $longitude}';
  }

  factory AddressLocation.fromMap(Map<String, dynamic> map) {
    return AddressLocation.withData(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static List<AddressLocation> fromList(List<dynamic> list) {
    return list.map((item) => AddressLocation.fromMap(item)).toList();
  }

  static List<Map<String, dynamic>> toList(List<AddressLocation> list) {
    return list.map((item) => item.toMap()).toList();
  }

  AddressLocation copyWith({double? latitude, double? longitude}) {
    return AddressLocation()
      ..latitude = latitude ?? this.latitude
      ..longitude = longitude ?? this.longitude;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AddressLocation &&
              runtimeType == other.runtimeType &&
              latitude == other.latitude &&
              longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

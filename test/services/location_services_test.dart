import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vegawallet/core/services/i_geo_locator_wrapper.dart';
import 'package:vegawallet/core/services/location_service.dart';


class MockGeolocatorWrapper extends Mock implements IGeolocatorWrapper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockGeolocatorWrapper mockGeolocator;
  late LocationService locationService;

  setUp(() {
    mockGeolocator = MockGeolocatorWrapper();
    locationService = LocationService(mockGeolocator);
  });

  setUpAll(() {
    registerFallbackValue(LocationAccuracy.high);
  });

  test('should throw exception when location services are disabled', () async {
    when(() => mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => false);
    expect(() => locationService.getCurrentPosition(), throwsException);

  });



  test('should throw exception when location permissions are denied', () async {
    when(() => mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
    when(() => mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);
    when(() => mockGeolocator.requestPermission()).thenAnswer((_) async => LocationPermission.denied);
    expect(() => locationService.getCurrentPosition(), throwsException);


  });

  test('should throw exception when location permissions are permanently denied', () async {
    when(() => mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
    when(() => mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.deniedForever);
    expect(() => locationService.getCurrentPosition(), throwsException);

  });
}

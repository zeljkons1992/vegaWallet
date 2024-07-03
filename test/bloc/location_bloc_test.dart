// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:vegawallet/features/stores/domain/entities/position.dart';
// import 'package:vegawallet/features/stores/domain/usecases/get_current_location_use_case.dart';
// import 'package:vegawallet/features/stores/presentation/bloc/location_bloc/location_bloc.dart';
//
// class MockGetCurrentLocationUseCase extends Mock implements GetCurrentLocationUseCase {}
//
// void main() {
//   late LocationBloc locationBloc;
//   late MockGetCurrentLocationUseCase mockGetCurrentLocationUseCase;
//
//   setUp(() {
//     mockGetCurrentLocationUseCase = MockGetCurrentLocationUseCase();
//     locationBloc = LocationBloc(mockGetCurrentLocationUseCase);
//   });
//
//   group('LocationBloc', () {
//     final testPosition = Position(
//       latitude: 37.42796133580664,
//       longitude: -122.085749655962,
//     );
//
//     test('initial state is LocationInitial', () {
//       expect(locationBloc.state, equals(LocationInitial()));
//     });
//
//     blocTest<LocationBloc, LocationState>(
//       'emits [LocationLoaded] when data is fetched successfully',
//       build: () {
//         when(() => mockGetCurrentLocationUseCase())
//             .thenAnswer((_) async => Future.value(testPosition));
//         return locationBloc;
//       },
//       act: (bloc) => bloc.add(GetLocation()),
//       expect: () => [
//         LocationLoaded(testPosition),
//       ],
//     );
//
//     blocTest<LocationBloc, LocationState>(
//       'emits [LocationError] when fetching data fails',
//       build: () {
//         when(() => mockGetCurrentLocationUseCase())
//             .thenThrow(Exception('Error fetching location'));
//         return locationBloc;
//       },
//       act: (bloc) => bloc.add(GetLocation()),
//       expect: () => [
//         LocationError("e"),
//       ],
//     );
//   });e
// }

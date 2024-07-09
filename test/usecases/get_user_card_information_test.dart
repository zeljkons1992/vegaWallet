import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockWalletCardInformation extends Mock implements WalletCardInformation {}

void main() {
  group('WalletRepository Tests', () {
    late WalletRepository mockWalletRepository;
    late WalletCardInformation fakeWalletCardInformation;

    setUpAll(() {
      mockWalletRepository = MockWalletRepository();
      fakeWalletCardInformation = MockWalletCardInformation();
      registerFallbackValue(MockWalletCardInformation());
    });

    setUp(() {
      when(() => fakeWalletCardInformation.name).thenReturn("Nikola Ranković");

    });

    test('should return success with valid data', () async {
      when(() => mockWalletRepository.getWalletCardInformation())
          .thenAnswer((_) async => DataState.success(fakeWalletCardInformation));

      final result = await mockWalletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.data!.name, equals("Nikola Ranković"));
    });

    test('should return error when data is invalid', () async {
      when(() => mockWalletRepository.getWalletCardInformation())
          .thenAnswer((_) async => DataState.error("Invalid data provided"));

      final result = await mockWalletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.message, equals("Invalid data provided"));
    });
  });
}
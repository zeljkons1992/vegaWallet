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
      when(() => fakeWalletCardInformation.expiry).thenReturn("12/25");
      when(() => fakeWalletCardInformation.cardNo).thenReturn("100 951");
    });

    test('should return success with valid data', () async {
      when(() => mockWalletRepository.getWalletCardInformation())
          .thenAnswer((_) async => DataState.success(fakeWalletCardInformation));

      final result = await mockWalletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.data!.name, equals("Nikola Ranković"));
      expect(result.data!.expiry, equals("12/25"));
      expect(result.data!.cardNo, equals("100 951"));
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
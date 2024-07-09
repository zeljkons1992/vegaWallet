import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/data/repository/wallet_repository_impl.dart';
import 'package:vegawallet/core/services/auth_services.dart';

class MockAuthServices extends Mock implements AuthService {}

void main() {
  group('WalletRepository Tests', () {
    late WalletRepositoryImpl walletRepositoryImpl;
    late MockAuthServices mockAuthServices;

    setUp(() {
      mockAuthServices = MockAuthServices();
      walletRepositoryImpl = WalletRepositoryImpl(mockAuthServices);
    });

    const walletCardInformation = WalletCardInformation(name: "Nikola");

    test('should return success with valid data', () async {
      when(() => mockAuthServices.getUserName())
          .thenAnswer((_) async => "Nikola");
      final result = await walletRepositoryImpl.getWalletCardInformation();

      expect(result.status, equals(DataStateStatus.success));
      expect(result.data?.name, equals(walletCardInformation.name));
    });

    test('should return error when user name is null', () async {
      // Mock the behavior of getUserName to return null
      when(() => mockAuthServices.getUserName())
          .thenAnswer((_) async => null);

      final result = await walletRepositoryImpl.getWalletCardInformation();

      expect(result.status, equals(DataStateStatus.error));
      expect(result.message, equals("No information"));
    });
  });
}

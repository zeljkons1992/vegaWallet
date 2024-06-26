import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/domain/usecases/get_user_card_information_use_case.dart';

import '../repository/repository_wallet_test.dart';

// Mock classes
class MockGetUserCardInformationUseCase extends Mock implements GetUserCardInformationUseCase {}

void main() {
  group("Wallet UseCase Tests", () {
    late MockGetUserCardInformationUseCase mockGetUserCardInformationUseCase;
    late WalletCardInformation fakeWalletCardInformation;

    setUpAll(() {
      mockGetUserCardInformationUseCase = MockGetUserCardInformationUseCase();
      fakeWalletCardInformation = MockCardInformation();
    });

    setUp(() {
      when(() => fakeWalletCardInformation.name).thenReturn("Nikola Ranković");
      when(() => fakeWalletCardInformation.expiry).thenReturn("12/25");
      when(() => fakeWalletCardInformation.cardNo).thenReturn("100 951");
    });

    test("should return success with valid data", () async {
      when(() => mockGetUserCardInformationUseCase.call())
          .thenAnswer((_) async => DataState.success(fakeWalletCardInformation));

      final result = await mockGetUserCardInformationUseCase.call();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.data!.name, equals("Nikola Ranković"));
      expect(result.data!.expiry, equals("12/25"));
      expect(result.data!.cardNo, equals("100 951"));
    });

    test("should return error when data is invalid", () async {
      when(() => mockGetUserCardInformationUseCase.call())
          .thenAnswer((_) async => DataState.error("Invalid data provided"));

      final result = await mockGetUserCardInformationUseCase.call();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.message, equals("Invalid data provided"));
    });
  });
}

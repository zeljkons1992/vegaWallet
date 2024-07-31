import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';
import 'package:vegawallet/features/wallet/domain/usecases/get_user_card_information_use_case.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

class MockWalletRepository extends Mock implements WalletRepository {}
class MockWalletBloc extends MockBloc<WalletEvent, WalletState> implements WalletBloc {}

void main() {
  group('WalletBloc', () {
    late MockWalletRepository mockWalletRepository;
    late GetUserCardInformationUseCase getUserCardInformationUseCase;
    late WalletBloc walletBloc;

    setUp(() {
      mockWalletRepository = MockWalletRepository();
      getUserCardInformationUseCase = GetUserCardInformationUseCase(mockWalletRepository);
      walletBloc = WalletBloc(getUserCardInformationUseCase);
    });

    test('emits initial state', () {
      expect(walletBloc.state, equals(WalletStateInitial()));
    });

    group('WalletBloc', () {
      blocTest<WalletBloc, WalletState>(
        'emits initial state when nothing is added',
        build: () => WalletBloc(getUserCardInformationUseCase),
        expect: () => <WalletState>[],
      );

      blocTest<WalletBloc, WalletState>(
        'emits loaded state when data is fetched successfully',
        build: () {
          // Mock the repository to return the expected data
          when(() => mockWalletRepository.getWalletCardInformation())
              .thenAnswer((_) async => DataState.success(
              const WalletCardInformation(
                  name: 'Nikola', expireDate: '12/25', cardNo: '111 111')));
          return WalletBloc(getUserCardInformationUseCase);
        },
        act: (bloc) => bloc.add(FetchCardInfo()),
        expect: () => [
          WalletStateLoading(),
          const WalletStateLoaded(WalletCardInformation(
              name: 'Nikola', expireDate: '12/25', cardNo: '111 111')),
        ],
      );

      blocTest<WalletBloc, WalletState>(
        'emits failed state when data is fetched unsuccessfully',
        build: () {
          when(() => mockWalletRepository.getWalletCardInformation())
              .thenAnswer((_) async => DataState.error(
              "Error"));
          return WalletBloc(getUserCardInformationUseCase);
        },
        act: (bloc) => bloc.add(FetchCardInfo()),
        expect: () => [
          WalletStateLoading(),
          const WalletStateError("Error"),
        ],
      );
    });
  });
}

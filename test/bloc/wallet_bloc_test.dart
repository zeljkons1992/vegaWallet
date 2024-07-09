import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';
import 'package:vegawallet/features/wallet/domain/usecases/get_user_card_information_use_case.dart';
import 'package:vegawallet/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

import '../widgets/widget_wallet_test.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  group('WalletBloc', () {
    late MockWalletBloc mockWalletBloc;
    late GetUserCardInformationUseCase getUserCardInformationUseCase;
    late WalletRepository mockWalletRepository;

    setUp(() {
      mockWalletBloc = MockWalletBloc();
      mockWalletRepository = MockWalletRepository();
      getUserCardInformationUseCase =
          GetUserCardInformationUseCase(mockWalletRepository);
    });

    test('emits initial state', () {
      whenListen(
        mockWalletBloc,
        Stream<WalletState>.fromIterable([WalletStateInitial()]),
        initialState: WalletStateInitial(),
      );
      expect(mockWalletBloc.state, WalletStateInitial());
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
                  name: 'Nikola')));
          return WalletBloc(getUserCardInformationUseCase);
        },
        act: (bloc) => bloc.add(FetchCardInfo()),
        expect: () => [
          WalletStateLoading(),
          const WalletStateLoaded(WalletCardInformation(
              name: 'Nikola')),
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
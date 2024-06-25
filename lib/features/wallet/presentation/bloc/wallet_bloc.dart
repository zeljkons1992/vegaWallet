import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';

import '../../domain/usecases/get_user_card_information_use_case.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

@Injectable()
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetUserCardInformationUseCase getUserCardInformationUseCase;

  WalletBloc(this.getUserCardInformationUseCase) : super(WalletStateInitial()) {
    on<FetchCardInfo>(_onFetchCardInfo);
  }

  Future<void> _onFetchCardInfo(
      FetchCardInfo event, Emitter<WalletState> emit) async {
    emit(WalletStateLoading());
    try {
      final result = await getUserCardInformationUseCase
          .call()
          .timeout(const Duration(seconds: 10));
      emit(WalletStateLoaded(result.data!));
    } on TimeoutException {
      emit(WalletStateError());
    } catch (e) {
      emit(WalletStateError());
    }
  }
}

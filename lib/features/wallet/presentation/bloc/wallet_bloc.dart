import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
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
    final result = await getUserCardInformationUseCase.call();
    if (result.status == DataStateStatus.success) {
      emit(WalletStateLoaded(result.data!));
    } else {
      emit(WalletStateError(result.message ?? "Failed to fetch data"));
    }
  }

}

part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable{
  const WalletState();

  @override
  List<Object> get props => [];
}
class WalletStateInitial extends WalletState{}

class WalletStateLoading extends WalletState{}

class WalletStateLoaded extends WalletState{
  final WalletCardInformation walletCardInformation;

  const WalletStateLoaded(this.walletCardInformation);

  @override
  List<Object> get props => [walletCardInformation];
}

class WalletStateError extends WalletState{
  final String error;
  const WalletStateError(this.error);
  @override
  List<Object> get props => [error];
}

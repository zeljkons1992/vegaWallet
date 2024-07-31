import 'package:equatable/equatable.dart';

class WalletCardInformation extends Equatable {
  final String name;
  final String expireDate;
  final String cardNo;


  const WalletCardInformation(
      {required this.name,required this.expireDate, required this.cardNo});

  @override
  // TODO: implement props
  List<Object?> get props => [name,expireDate,cardNo];
}

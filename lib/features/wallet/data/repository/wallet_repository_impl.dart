import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegawallet/core/constants/text_const.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/domain/repository/wallet_repository.dart';
import '../../../../core/services/auth_services.dart';
import '../../../stores/data/data_sources/spreadsheet_downloader.dart';
import '../../domain/utils/wallet_excel_parser.dart';

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final AuthService _authServices;
  final SpreadsheetDownloader _spreadsheetDownloader;
  final WalletExcelParser _parser;

  WalletRepositoryImpl(
      this._authServices, this._spreadsheetDownloader, this._parser);

  @override
  Future<DataState<WalletCardInformation>> getWalletCardInformation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user = prefs.getString('user_name');
      String? cardNumber = prefs.getString('card_number');
      String? expireDate = prefs.getString('expire_date');

      if (user == null || cardNumber == null || expireDate == null) {
        user = await _authServices.getUserName();
        if (user == null) {
          return DataState.error("User not found");
        }

        final response = await _spreadsheetDownloader.downloadExcelFile(
          dotenv.env['EXCEL_FORMAT']!,
          dotenv.env['EXCEL_URL2']!,
        );
        final bytes = Uint8List.fromList(response.data);

        List<String> nameParts = user.split(' ');

        cardNumber = _parser.getCardNumber(bytes, nameParts[0], nameParts[1]);
        if (cardNumber == null) {
          return DataState.error("No matching card number found");
        }

        expireDate = TextConst.expireDate;

        prefs.setString('user_name', user);
        prefs.setString('card_number', cardNumber);
        prefs.setString('expire_date', expireDate);
      }

      WalletCardInformation walletCardInformation = WalletCardInformation(
        name: user,
        expireDate: expireDate,
        cardNo: cardNumber,
      );

      return DataState.success(walletCardInformation);

    } catch (e) {
      return DataState.error("Failed to fetch data: $e");
    }
  }
}

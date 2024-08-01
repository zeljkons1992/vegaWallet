import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:diacritic/diacritic.dart';

@LazySingleton()
class WalletExcelParser {
  String? getCardNumber(Uint8List bytes, String name, String surname) {
    var excel = Excel.decodeBytes(bytes);
    var sheet = excel.tables['Ceo spisak'];

    name = removeDiacritics(name.trim().toLowerCase());
    surname = removeDiacritics(surname.trim().toLowerCase());

    if (sheet != null && sheet.maxRows > 1) {
      try {
        return sheet.rows.skip(1).firstWhere((row) {
            String? rowName = row[1]?.value?.toString().trim().toLowerCase();
            String? rowSurname = row[2]?.value?.toString().trim().toLowerCase();

            rowName = rowName != null ? removeDiacritics(rowName) : null;
            rowSurname =
            rowSurname != null ? removeDiacritics(rowSurname) : null;

            return rowName == name && rowSurname == surname;
          },
        )[0]?.value?.toString();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
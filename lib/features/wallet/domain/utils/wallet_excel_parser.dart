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
      for (int i = 1; i < sheet.maxRows; i++) {
        var row = sheet.row(i);
        String? rowName = row[1]?.value?.toString().trim().toLowerCase();
        String? rowSurname = row[2]?.value?.toString().trim().toLowerCase();

        rowName = rowName != null ? removeDiacritics(rowName) : null;
        rowSurname = rowSurname != null ? removeDiacritics(rowSurname) : null;


        if (rowName == name && rowSurname == surname) {
          return row[0]?.value?.toString();
        }
      }
    }

    return null;
  }
}

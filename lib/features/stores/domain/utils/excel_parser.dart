import 'package:injectable/injectable.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

@LazySingleton()
class ExcelParser {
  Map<String, List<List<dynamic>>> parse(SpreadsheetDecoder decoder) {
    final tables = <String, List<List<dynamic>>>{};

    for (var table in decoder.tables.keys) {
      var sheet = decoder.tables[table];
      tables[table] = sheet!.rows;
    }

    return tables;
  }
}

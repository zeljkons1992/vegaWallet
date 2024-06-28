import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

import 'excel_decoder_wrapper.dart';
import 'excel_mapper.dart';

@LazySingleton()
class ExcelParser {
  final ExcelDecoderWrapper excelDecoder;
  final ExcelMapper excelMapper;

  ExcelParser({required this.excelDecoder, required this.excelMapper});

  List<Store> parse(Uint8List bytes) {
    final decoder = excelDecoder.decode(bytes);
    final tables = <String, List<List<dynamic>>>{};

    for (var table in decoder.tables.keys) {
      var sheet = decoder.tables[table];
      tables[table] = sheet!.rows;
    }

    return excelMapper.mapTablesToStores(tables);
  }
}

import 'dart:typed_data';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ExcelDecoderWrapper {
  SpreadsheetDecoder decode(Uint8List bytes) {
    return SpreadsheetDecoder.decodeBytes(bytes, update: true);
  }
}

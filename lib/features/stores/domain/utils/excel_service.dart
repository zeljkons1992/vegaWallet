import 'package:injectable/injectable.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';
import 'excel_parser.dart';
import 'excel_mapper.dart';

@LazySingleton()
class ExcelService {
  final StoreRepository repository;
  final ExcelParser parser;
  final ExcelMapper mapper;

  ExcelService({
    required this.repository,
    required this.parser,
    required this.mapper,
  });

  Future<List<Store>> fetchAndProcessSpreadsheet() async {
    try {
      final bytes = await repository.fetchSpreadsheet();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
      final parsedData = parser.parse(decoder);
      final stores = mapper.map(parsedData);
      return stores;
    } catch (e) {
      throw Exception('Error fetching and processing spreadsheet: $e');
    }
  }
}

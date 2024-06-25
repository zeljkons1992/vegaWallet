import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:vegawallet/features/stores/data/data_sources/local_data_source.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';
import 'excel_parser.dart';
import 'excel_mapper.dart';

@LazySingleton()
class ExcelService {
  final StoreRepository repository;
  final ExcelParser parser;
  final ExcelMapper mapper;
  final ExcelDecoderService decoderService;
  final LocalDataSource localDataSource;


  ExcelService({
    required this.repository,
    required this.parser,
    required this.mapper,
    required this.decoderService,
    required this.localDataSource,
  });

  Future<List<Store>> fetchAndProcessSpreadsheet() async {
    try {
      final bytes = await repository.fetchSpreadsheet();
      final decoder = decoderService.decodeBytes(bytes);
      final parsedData = parser.parse(decoder);
      final stores = mapper.map(parsedData);
      await localDataSource.writeStores(stores);

      return stores;
    } catch (e) {
      throw Exception('Error fetching and processing spreadsheet: $e');
    }
  }
}

@Injectable()
class ExcelDecoderService {
  SpreadsheetDecoder decodeBytes(Uint8List bytes) {
    return SpreadsheetDecoder.decodeBytes(bytes, update: true);
  }
}

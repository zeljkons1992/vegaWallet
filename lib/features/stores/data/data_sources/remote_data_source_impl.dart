import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/stores/domain/datasources/remote_data_source.dart';
import '../../domain/entities/store.dart';
import '../../domain/utils/excel_parser.dart';
import '../data_sources/spreadsheet_downloader.dart';

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final SpreadsheetDownloader spreadsheetDownloader;
  final ExcelParser parser;

  RemoteDataSourceImpl({
    required this.spreadsheetDownloader,
    required this.parser,
  });

  @override
  Future<List<Store>> fetchStores() async {
    final response = await spreadsheetDownloader.downloadExcelFile(dotenv.env['EXCEL_FORMAT']!, dotenv.env['EXCEL_URL']!);
    final bytes = Uint8List.fromList(response.data);
    final stores = parser.parse(bytes);
    return stores;
  }
}

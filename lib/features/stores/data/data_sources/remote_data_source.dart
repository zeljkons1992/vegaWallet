// data/data_sources/remote_data_source.dart
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/store.dart';
import '../../domain/utils/excel_parser.dart';
import '../data_sources/api_client.dart';

@LazySingleton()
class RemoteDataSource {
  final ApiClient apiClient;
  final ExcelParser parser;

  RemoteDataSource({
    required this.apiClient,
    required this.parser,
  });

  Future<List<Store>> fetchStores() async {
    final response = await apiClient.downloadExcelFile(dotenv.env['EXCEL_FORMAT']!, dotenv.env['EXCEL_URL']!);
    final bytes = Uint8List.fromList(response.data);
    final stores = parser.parse(bytes);
    return stores;
  }
}

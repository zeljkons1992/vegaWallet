import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import '../data_sources/api_client.dart';
import '../../domain/repository/store_repository.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl implements StoreRepository {
  final ApiClient apiClient;

  StoreRepositoryImpl({required this.apiClient});

  @override
  Future<Uint8List> fetchSpreadsheet() async {
    try {
      final response = await apiClient.downloadExcelFile(dotenv.env['EXCEL_FORMAT']!, dotenv.env['EXCEL_URL']!);
      if (response.response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('Failed to fetch Excel file: ${response.response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching spreadsheet: $e');
    }
  }
}

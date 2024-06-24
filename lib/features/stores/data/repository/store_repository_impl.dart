import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:retrofit/retrofit.dart';
import '../data_sources/api_client.dart';
import '../../domain/entities/store.dart';
import '../../domain/repository/store_repository.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl implements StoreRepository {
  final ApiClient apiClient;

  StoreRepositoryImpl({required this.apiClient});

  @override
  Future<List<Store>> fetchStores() async {
    try {
      // Fetch the file using Retrofit
      final response = await apiClient.downloadExcelFile('xlsx', '1pkLx5AoPiULXUxB-ZbQIKyiGpqt_TspXy0xENkvgeNo');
      print('Fetched response: ${response.response.statusCode}');

      if (response.response.statusCode == 200) {
        // Decode the spreadsheet
        Uint8List bytes = Uint8List.fromList(response.data!);
        print('Fetched bytes length: ${bytes.length}');
        SpreadsheetDecoder decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
        List<Store> stores = [];

        var table = decoder.tables.keys.first;
        var sheet = decoder.tables[table];
        print('Decoded table: $table');

        String? currentName;
        List<List<dynamic>> currentRows = [];

        for (var row in sheet!.rows.skip(1)) {
          if (row[1] != null && row[1].toString().isNotEmpty) {
            if (currentName != null) {
              final store = Store.fromMap(currentName, currentRows);
              stores.add(store);
            }
            currentName = row[1].toString();
            currentRows = [row];
          } else if (currentName != null) {
            currentRows.add(row);
          }
        }

        // Add the last store
        if (currentName != null) {
          final store = Store.fromMap(currentName, currentRows);
          stores.add(store);
        }

        // Print out the list of stores
        for (var store in stores) {
          print(store);
        }

        return stores;
      } else {
        print('Failed to fetch Excel file: ${response.response.statusCode}');
        throw Exception('Failed to fetch Excel file');
      }
    } catch (e) {
      print('Error fetching and decoding spreadsheet: $e');
      throw Exception('Failed to load data');
    }
  }
}

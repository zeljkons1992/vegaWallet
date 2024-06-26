import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vegawallet/features/stores/data/data_sources/remote_data_source_impl.dart';
import 'package:vegawallet/features/stores/data/data_sources/spreadsheet_downloader.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_parser.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

import 'remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SpreadsheetDownloader, ExcelParser])
void main() {
  late RemoteDataSourceImpl remoteDataSource;
  late MockSpreadsheetDownloader mockSpreadsheetDownloader;
  late MockExcelParser mockExcelParser;

  setUp(() {
    mockSpreadsheetDownloader = MockSpreadsheetDownloader();
    mockExcelParser = MockExcelParser();

    remoteDataSource = RemoteDataSourceImpl(
      spreadsheetDownloader: mockSpreadsheetDownloader,
      parser: mockExcelParser,
    );

    dotenv.testLoad(fileInput: '''
EXCEL_FORMAT=xlsx
EXCEL_URL=http://example.com/spreadsheet
''');

  });

  test('should fetch and parse stores from remote source', () async {
    // Arrange
    final mockBytes = Uint8List(0);
    final stores = [
      Store.withData(
        name: 'Store1',
        addressCities: [],
        discounts: [],
        conditions: [],
        category: 'Test',
      ),
    ];

    when(mockSpreadsheetDownloader.downloadExcelFile(any, any)).thenAnswer((_) async => HttpResponse(mockBytes, Response(requestOptions: RequestOptions())));
    when(mockExcelParser.parse(any)).thenReturn(stores);

    // Act
    final result = await remoteDataSource.fetchStores();

    // Assert
    verify(mockSpreadsheetDownloader.downloadExcelFile(any, any)).called(1);
    verify(mockExcelParser.parse(mockBytes)).called(1);
    expect(result, stores);
  });
}

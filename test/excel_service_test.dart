import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:vegawallet/features/stores/data/data_sources/local_data_source.dart';
import 'package:vegawallet/features/stores/domain/entities/address_city.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/repository/store_repository.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_mapper.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_parser.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_service.dart';
import 'excel_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ExcelMapper>()])
@GenerateNiceMocks([MockSpec<ExcelParser>()])
@GenerateNiceMocks([MockSpec<StoreRepository>()])
@GenerateNiceMocks([MockSpec<ExcelDecoderService>()])
@GenerateNiceMocks([MockSpec<SpreadsheetDecoder>()])
@GenerateNiceMocks([MockSpec<LocalDataSource>()])

void main() {
  group('Excel Service', () {
    late MockExcelMapper mockExcelMapper;
    late MockExcelParser mockExcelParser;
    late MockStoreRepository mockStoreRepository;
    late MockExcelDecoderService mockExcelDecoderService;
    late ExcelService excelService;
    late MockSpreadsheetDecoder mockSpreadsheetDecoder;
    late MockLocalDataSource mockLocalDataSource;

    setUp(() {
      mockStoreRepository = MockStoreRepository();
      mockExcelMapper = MockExcelMapper();
      mockExcelParser = MockExcelParser();
      mockExcelDecoderService = MockExcelDecoderService();
      mockSpreadsheetDecoder = MockSpreadsheetDecoder();
      mockLocalDataSource = MockLocalDataSource();


      excelService = ExcelService(
        repository: mockStoreRepository,
        parser: mockExcelParser,
        mapper: mockExcelMapper,
        decoderService: mockExcelDecoderService,
        localDataSource: mockLocalDataSource,
      );
    });

    test('should fetch and process spreadsheet correctly', () async {
      final mockBytes = Uint8List(0);
      when(mockStoreRepository.fetchSpreadsheet()).thenAnswer((_) async => mockBytes);
      when(mockExcelDecoderService.decodeBytes(any)).thenReturn(mockSpreadsheetDecoder);

      final mockData = {
        'Sheet1': [
          ['Header1', 'Header2', 'Header3', 'Header4', 'Header5'],
          ['1', 'Store1', 'Address1', 'City1', 'Discount1', 'Condition1'],
          ['2', '', 'Address2', '', '', ''],
          ['3', 'Store2', 'Address3', 'City2', 'Discount2', 'Condition2'],
        ],
      };

      when(mockExcelParser.parse(mockSpreadsheetDecoder)).thenAnswer((_) => mockData);

      final stores = <Store>[
        Store.withData(
          name: 'Store1',
          addressCities: [
            AddressCity.withData(address: 'Address1', city: 'City1'),
            AddressCity.withData(address: 'Address2', city: 'City1'),
          ],
          discounts: ['Discount1'],
          conditions: ['Condition1'],
          category: 'Sheet1',
        ),
        Store.withData(
          name: 'Store2',
          addressCities: [
            AddressCity.withData(address: 'Address3', city: 'City2'),
          ],
          discounts: ['Discount2'],
          conditions: ['Condition2'],
          category: 'Sheet1',
        ),
      ];

      when(mockExcelMapper.map(mockData)).thenReturn(stores);

      final result = await excelService.fetchAndProcessSpreadsheet();

      verify(mockStoreRepository.fetchSpreadsheet()).called(1);
      verify(mockExcelDecoderService.decodeBytes(any)).called(1);
      verify(mockExcelParser.parse(mockSpreadsheetDecoder)).called(1);
      verify(mockExcelMapper.map(mockData)).called(1);
      verify(mockLocalDataSource.writeStores(stores)).called(1);

      expect(result, stores);
    });
  });
}

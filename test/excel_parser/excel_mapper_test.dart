import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vegawallet/features/stores/domain/entities/address_city.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_decoder_wrapper.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_parser.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_mapper.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'excel_parser_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SpreadsheetDecoder>(), MockSpec<SpreadsheetTable>(), MockSpec<ExcelDecoderWrapper>()])
void main() {
  group('ExcelParser', () {
    late ExcelParser parser;
    late MockSpreadsheetDecoder mockSpreadsheetDecoder;
    late MockSpreadsheetTable mockSpreadsheetTable;
    late MockExcelDecoderWrapper mockExcelDecoderWrapper;
    late ExcelMapper excelMapper;  // Use the actual ExcelMapper instead of mocking it

    setUp(() {
      mockSpreadsheetDecoder = MockSpreadsheetDecoder();
      mockSpreadsheetTable = MockSpreadsheetTable();
      mockExcelDecoderWrapper = MockExcelDecoderWrapper();
      excelMapper = ExcelMapper();  // Initialize the real ExcelMapper

      parser = ExcelParser(
        excelDecoder: mockExcelDecoderWrapper,
        excelMapper: excelMapper,
      );
    });

    test('should parse spreadsheet and return tables map', () {
      // Arrange
      when(mockExcelDecoderWrapper.decode(any)).thenReturn(mockSpreadsheetDecoder);
      when(mockSpreadsheetTable.rows).thenReturn([
        ['Header1', 'Naziv objekta', 'Adresa', 'Grad', 'Popust', 'Uslovi'],
        ['1', 'Store1', 'Address1', 'City1', '10%', 'Condition1'],
        ['2', 'Store2', 'Address2', 'City2', '20%', 'Condition2'],
        ['3', 'Store3', 'Address3', 'City3', '10%', 'Condition3'],
      ]);
      when(mockSpreadsheetDecoder.tables).thenReturn({'Sheet1': mockSpreadsheetTable});

      final expectedData = [
        Store.withData(
          name: 'Store1',
          addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
          discounts: ['10%'],
          conditions: ['Condition1'],
          category: 'Sheet1',
          parsedDiscount: 10,
        ),
        Store.withData(
          name: 'Store2',
          addressCities: [AddressCity.withData(address: 'Address2', city: 'City2')],
          discounts: ['20%'],
          conditions: ['Condition2'],
          category: 'Sheet1',
          parsedDiscount: 20,
        ),
        Store.withData(
          name: 'Store3',
          addressCities: [AddressCity.withData(address: 'Address3', city: 'City3')],
          discounts: ['10%'],
          conditions: ['Condition3'],
          category: 'Sheet1',
          parsedDiscount: 10,
        ),
      ];

      // Act
      final result = parser.parse(Uint8List(0));

      // Assert
      expect(result.map((store) => store.toMap()).toList(), expectedData.map((store) => store.toMap()).toList());
    });
  });
}

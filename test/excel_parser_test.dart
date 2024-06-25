import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vegawallet/features/stores/domain/entities/address_city.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_parser.dart';
import 'excel_parser_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SpreadsheetDecoder>(), MockSpec<SpreadsheetTable>(), MockSpec<ExcelDecoderWrapper>()])
void main() {
  group('ExcelParser', () {
    late ExcelParser parser;
    late MockSpreadsheetDecoder mockSpreadsheetDecoder;
    late MockSpreadsheetTable mockSpreadsheetTable;
    late MockExcelDecoderWrapper mockExcelDecoderWrapper;

    setUp(() {
      mockSpreadsheetDecoder = MockSpreadsheetDecoder();
      mockSpreadsheetTable = MockSpreadsheetTable();
      mockExcelDecoderWrapper = MockExcelDecoderWrapper();

      parser = ExcelParser(
        excelDecoder: mockExcelDecoderWrapper,
      );
    });

    test('should parse spreadsheet and return tables map', () {
      // Arrange
      when(mockExcelDecoderWrapper.decode(any)).thenReturn(mockSpreadsheetDecoder);
      when(mockSpreadsheetTable.rows).thenReturn([
        ['Header1', 'Header2', 'Header3', 'Header4', 'Header5', 'Header6'],
        ['1', 'Store1', 'Address1', 'City1', 'Discount1', 'Condition1'],
        ['2', 'Store2', 'Address2', 'City2', 'Discount2', 'Condition2'],
        ['3', 'Store3', 'Address3', 'City3', 'Discount3', 'Condition3'],
      ]);
      when(mockSpreadsheetDecoder.tables).thenReturn({'Sheet1': mockSpreadsheetTable});

      final expectedData = [
        Store.withData(
          name: 'Store1',
          addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
          discounts: ['Discount1'],
          conditions: ['Condition1'],
          category: 'Sheet1',
        ),
        Store.withData(
          name: 'Store2',
          addressCities: [AddressCity.withData(address: 'Address2', city: 'City2')],
          discounts: ['Discount2'],
          conditions: ['Condition2'],
          category: 'Sheet1',
        ),
        Store.withData(
          name: 'Store3',
          addressCities: [AddressCity.withData(address: 'Address3', city: 'City3')],
          discounts: ['Discount3'],
          conditions: ['Condition3'],
          category: 'Sheet1',
        ),
      ];

      // Act
      final result = parser.parse(Uint8List(0));

      // Assert
      expect(result.map((store) => store.toMap()).toList(), expectedData.map((store) => store.toMap()).toList());
    });
  });
}

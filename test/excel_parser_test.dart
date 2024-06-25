import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_parser.dart';
import 'excel_parser_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SpreadsheetDecoder>(), MockSpec<SpreadsheetTable>()])
void main() {
  group('ExcelParser', () {
    late ExcelParser parser;
    late MockSpreadsheetDecoder mockSpreadsheetDecoder;
    late MockSpreadsheetTable mockSpreadsheetTable;

    setUp(() {
      parser = ExcelParser();
      mockSpreadsheetDecoder = MockSpreadsheetDecoder();
      mockSpreadsheetTable = MockSpreadsheetTable();
    });

    test('should parse spreadsheet and return tables map', () {
      // Arrange
      when(mockSpreadsheetTable.rows).thenReturn([
        ['Header1', 'Header2', 'Header3', 'Header4', 'Header5'],
        ['1', 'Store1', 'Address1', 'City1', 'Discount1'],
        ['2', 'Store2', 'Address2', 'City2', 'Discount2'],
        ['3', 'Store3', 'Address3', 'City3', 'Discount3'],
      ]);
      when(mockSpreadsheetDecoder.tables).thenReturn({'Sheet1': mockSpreadsheetTable});

      final expectedData = {
        'Sheet1': [
          ['Header1', 'Header2', 'Header3', 'Header4', 'Header5'],
          ['1', 'Store1', 'Address1', 'City1', 'Discount1'],
          ['2', 'Store2', 'Address2', 'City2', 'Discount2'],
          ['3', 'Store3', 'Address3', 'City3', 'Discount3'],
        ],
      };

      // Act
      final result = parser.parse(mockSpreadsheetDecoder);

      // Assert
      expect(result, expectedData);
    });
  });
}

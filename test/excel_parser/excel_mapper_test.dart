import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/features/stores/domain/entities/address_city.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_mapper.dart';

void main() {
  group('ExcelMapper', () {
    late ExcelMapper mapper;

    setUp(() {
      mapper = ExcelMapper();
    });

    test('should map tables to stores correctly', () {
      // Arrange
      final tables = {
        'Sheet1': [
          ['Header1', 'Header2', 'Header3', 'Header4', 'Header5', 'Header6'],
          ['1', 'Store1', 'Address1', 'City1', 'Discount1', 'Condition1'],
          ['2', 'Store2', 'Address2', 'City2', 'Discount2', 'Condition2'],
          ['3', 'Store3', 'Address3', 'City3', 'Discount3', 'Condition3'],
        ]
      };

      final expectedData = [
        Store.withData(
          name: 'Store1',
          addressCities: [
            AddressCity.withData(address: 'Address1', city: 'City1'),
          ],
          discounts: ['Discount1'],
          conditions: ['Condition1'],
          category: 'Sheet1',
        ),
        Store.withData(
          name: 'Store2',
          addressCities: [
            AddressCity.withData(address: 'Address2', city: 'City2'),
          ],
          discounts: ['Discount2'],
          conditions: ['Condition2'],
          category: 'Sheet1',
        ),
        Store.withData(
          name: 'Store3',
          addressCities: [
            AddressCity.withData(address: 'Address3', city: 'City3'),
          ],
          discounts: ['Discount3'],
          conditions: ['Condition3'],
          category: 'Sheet1',
        ),
      ];

      // Act
      final result = mapper.mapTablesToStores(tables);

      // Assert
      expect(result.map((store) => store.toMap()).toList(), expectedData.map((store) => store.toMap()).toList());
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_mapper.dart';


void main() {
  group('ExcelMapper', () {
    late ExcelMapper mapper;

    setUp(() {
      mapper = ExcelMapper();
    });

    test('should map tables correctly', () {
      final tables = {
        'Sheet1': [
          ['Header1', 'Header2', 'Header3', 'Header4', 'Header5'],
          [1, 'Store1', 'Address1', 'City1', 'Discount1', 'Condition1'],
          [2, '', 'Address2', '', '', ''],
          [3, 'Store2', 'Address3', 'City2', 'Discount2', 'Condition2'],
        ],
      };

      final stores = mapper.map(tables);

      expect(stores.length, 2);
      expect(stores[0].name, 'Store1');
      expect(stores[0].addressCities.length, 2);
      expect(stores[0].addressCities[0].address, 'Address1');
      expect(stores[0].addressCities[0].city, 'City1');
      expect(stores[0].addressCities[1].address, 'Address2');
      expect(stores[0].addressCities[1].city, 'City1');
      expect(stores[1].name, 'Store2');
      expect(stores[1].addressCities.length, 1);
      expect(stores[1].addressCities[0].address, 'Address3');
      expect(stores[1].addressCities[0].city, 'City2');
    });
  });
}

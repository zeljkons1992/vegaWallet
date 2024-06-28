import 'package:flutter_test/flutter_test.dart';
import 'package:vegawallet/features/stores/domain/entities/address_city.dart';
import 'package:vegawallet/features/stores/domain/entities/store.dart';

void main() {
  group('Store Model', () {
    test('should create a Store object correctly', () {
      final store = Store.withData(
        name: 'Store1',
        addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
        discounts: ['Discount1'],
        conditions: ['Condition1'],
        category: 'Category1',
      );

      expect(store.name, 'Store1');
      expect(store.addressCities.length, 1);
      expect(store.discounts.length, 1);
      expect(store.conditions.length, 1);
      expect(store.category, 'Category1');
    });

    test('should convert Store object to map correctly', () {
      final store = Store.withData(
        name: 'Store1',
        addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
        discounts: ['Discount1'],
        conditions: ['Condition1'],
        category: 'Category1',
      );

      final map = store.toMap();

      expect(map['name'], 'Store1');
      expect(map['addressCities'][0]['address'], 'Address1');
      expect(map['discounts'][0], 'Discount1');
      expect(map['conditions'][0], 'Condition1');
      expect(map['category'], 'Category1');
    });

    test('should compare two Store objects correctly', () {
      final store1 = Store.withData(
        name: 'Store1',
        addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
        discounts: ['Discount1'],
        conditions: ['Condition1'],
        category: 'Category1',
      );

      final store2 = Store.withData(
        name: 'Store1',
        addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
        discounts: ['Discount1'],
        conditions: ['Condition1'],
        category: 'Category1',
      );

      expect(store1 == store2, equals(true));
    });

    test('should not compare two different Store objects', () {
      final store1 = Store.withData(
        name: 'Store1',
        addressCities: [AddressCity.withData(address: 'Address1', city: 'City1')],
        discounts: ['Discount1'],
        conditions: ['Condition1'],
        category: 'Category1',
      );

      final store2 = Store.withData(
        name: 'Store2',
        addressCities: [AddressCity.withData(address: 'Address2', city: 'City2')],
        discounts: ['Discount2'],
        conditions: ['Condition2'],
        category: 'Category2',
      );

      expect(store1, isNot(equals(store2)));
    });
  });
}

import 'dart:typed_data';

abstract class StoreRepository {
  Future<Uint8List> fetchSpreadsheet();
}

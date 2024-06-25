import 'package:injectable/injectable.dart';
import 'package:vegawallet/features/stores/domain/utils/excel_service.dart';
import '../entities/store.dart';

@Injectable()
class FetchStoresUseCase {
  final ExcelService service;

  FetchStoresUseCase({required this.service});

  Future<List<Store>> call() async {
    return await service.fetchAndProcessSpreadsheet();
  }
}

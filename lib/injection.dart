import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'injection.config.dart';

import 'features/stores/data/data_sources/spreadsheet_downloader.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() =>  getIt.init();

@module
abstract class InjectableModule {
  @LazySingleton()
  Map<String, String> get headers => {"accept": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"};

  @LazySingleton()
  Dio dio() {
    final baseUrl = dotenv.env['EXCEL_BASE_URL']!;
    final headers = <String, String>{}; // Add any necessary headers here

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      ),
    );

    return dio;
  }

  // @singleton
  // @preResolve
  // Future<Isar> provideIsar() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   return await Isar.open([StoreModelSchema], directory: dir.path);
  // }

  @LazySingleton()
  SpreadsheetDownloader provideApiClient(Dio dio) {
    return SpreadsheetDownloader(dio);
  }


}
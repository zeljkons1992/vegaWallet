import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

import 'features/stores/data/data_sources/api_client.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() =>  getIt.init();

@module
abstract class InjectableModule {
  @LazySingleton()
  Map<String, String> get headers => {"accept": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"};

  @LazySingleton()
  Dio dio(Map<String, String> headers) {
    final dio = Dio(BaseOptions(headers: headers));
    return dio;
  }

  // @singleton
  // @preResolve
  // Future<Isar> provideIsar() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   return await Isar.open([StoreModelSchema], directory: dir.path);
  // }

  @LazySingleton()
  ApiClient provideApiClient(Dio dio) {
    return ApiClient(dio);
  }


}
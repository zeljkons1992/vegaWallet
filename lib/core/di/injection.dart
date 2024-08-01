import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vegawallet/core/di/injection.config.dart';

import '../../features/stores/data/data_sources/spreadsheet_downloader.dart';
import '../../features/stores/domain/entities/store.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();

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

  @Singleton()
  @preResolve
  Future<Isar> provideIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([StoreSchema], directory: dir.path);
  }

  @LazySingleton()
  SpreadsheetDownloader provideApiClient(Dio dio) {
    return SpreadsheetDownloader(dio);
  }

  // Register FirebaseAuth
  @LazySingleton()
  FirebaseAuth provideFirebaseAuth() {
    return FirebaseAuth.instance;
  }

  // Register GoogleSignIn
  @LazySingleton()
  GoogleSignIn provideGoogleSignIn() {
    return GoogleSignIn();
  }
}
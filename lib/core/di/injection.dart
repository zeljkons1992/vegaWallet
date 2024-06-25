
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/di/injection.config.dart';


final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() =>getIt.init();
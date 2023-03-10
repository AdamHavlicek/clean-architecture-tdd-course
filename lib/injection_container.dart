
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.config.dart';

final getIt = GetIt.instance;

@module
abstract class RegisterModule {

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker => InternetConnectionChecker(); 

  @lazySingleton
  http.Client get httpClient => http.Client();

  @preResolve
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();
}

@injectableInit
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.init();
}
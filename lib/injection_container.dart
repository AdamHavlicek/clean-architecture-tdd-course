import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/store/app_epic.dart';
import 'core/store/app_state.dart';
import 'core/store/app_store.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @lazySingleton
  EpicMiddleware<AppState> get epicMiddleware {
    return EpicMiddleware<AppState>(
      getIt<AppEpic>().combinedEpic,
    );
  }

  @lazySingleton
  AppStore get store {
    return AppStore(
      middleware: [
        epicMiddleware.call,
        LoggingMiddleware.printer().call,
      ],
    );
  }

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  @lazySingleton
  http.Client get httpClient => http.Client();

  @preResolve
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();
}

@InjectableInit(preferRelativeImports: true)
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getIt.init();
}

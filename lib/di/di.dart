import 'package:admin_server/config/app_config.dart';
import 'package:admin_server/controllers/admin_controller.dart';
import 'package:admin_server/data/user_repository/user_repository.dart';
import 'package:admin_server/data/user_repository/user_repository_impl.dart';
import 'package:admin_server/data/xray_repository/xray_repository.dart';
import 'package:admin_server/data/xray_repository/xray_repository_impl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup(AppConfig appConfig) {
  getIt.registerSingleton<AppConfig>(appConfig);
  // Repositories
  getIt.registerSingleton<UserRepository>(UserRepositoryImpl());
  getIt.registerSingleton<XrayRepository>(
    XrayRepositoryImpl(appConfig: getIt<AppConfig>()),
  );

  // Controllers
  getIt.registerSingleton<AdminController>(
    AdminController(
      userRepository: getIt<UserRepository>(),
      xrayRepository: getIt<XrayRepository>(),
    ),
  );
}

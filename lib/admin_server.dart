import 'package:admin_server/config/app_config.dart';
import 'package:admin_server/data/hive_initializer.dart';
import 'package:admin_server/di/di.dart' as di;
import 'package:admin_server/utils/log_console.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'routes/api_routes.dart';

void main(List<String> arguments) async {
  logConsole("Starting server...");
  final appConfig = await AppConfig.load(arguments);

  await HiveInitializer.init();

  di.setup(appConfig);

  final apiRoutes = ApiRoutes();

  final router = Router();
  router.mount(AppConfig.basePath, apiRoutes.router.call);

  final server = await serve(
    router.call,
    appConfig.host,
    appConfig.port,
  );

  logConsole('I am ready to serve :)\nhttp://${server.address.host}:${server.port}');
}

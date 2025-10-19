import 'dart:io';

import 'package:admin_server/utils/log_console.dart';
import 'package:dotenv/dotenv.dart';

class AppConfig {
  const AppConfig({
    required this.host,
    required this.port,
    required this.pathToConfig,
    required this.pathToCompose,
    required this.vlessTemplate,
  });

  final String host;
  final int port;
  final String pathToConfig;
  final String pathToCompose;
  final String vlessTemplate;

  static const String apiVersion = 'v1';
  static const String basePath = '/api/$apiVersion';

  static Future<AppConfig> load(List<String> arguments) async {
    logConsole("Loading env...");
    final env = DotEnv()..load();
    final host = env['HOST'];
    final port = env['PORT'];
    final pathToConfig = env["CONFIG_PATH"] ?? "";
    final pathToCompose = env["COMPOSE_PATH"] ?? "";
    final vlessTemplate = env["VLESS_TEMPLATE"] ?? "";

    if (host == null || port == null) {
      throw Exception('Not found environment variables for HOST or PORT');
    }

    if (File(pathToConfig).existsSync() == false) {
      throw Exception('Config file not found: $pathToConfig');
    }

    if (File(pathToCompose).existsSync() == false) {
      throw Exception('Compose file not found: $pathToCompose');
    }

    if (vlessTemplate.trim().isEmpty) {
      throw Exception('VLESS template is empty');
    }

    logConsole(
      "Env loaded!\nHOST: $host\nPORT: $port\nConfig file: $pathToConfig\nCompose file: $pathToCompose\nVLESS template: $vlessTemplate",
    );

    return AppConfig(
      host: host,
      port: int.parse(port),
      pathToConfig: pathToConfig,
      pathToCompose: pathToCompose,
      vlessTemplate: vlessTemplate,
    );
  }
}

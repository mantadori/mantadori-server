import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:admin_server/config/app_config.dart';
import 'package:admin_server/data/xray_repository/xray_repository.dart';
import 'package:admin_server/models/user.dart';
import 'package:admin_server/utils/log_console.dart';

class XrayRepositoryImpl implements XrayRepository {
  XrayRepositoryImpl({required this.appConfig});

  final AppConfig appConfig;

  @override
  Future<String> generateLink(User user) async {
    final template = appConfig.vlessTemplate;
    return template.replaceAll("<<<SID>>>", user.sId).replaceAll("<<<NAME>>>", user.name);
  }

  @override
  Future<String> generateSID() async {
    if (Platform.isLinux) {
      final result = await Process.run('openssl', ['rand', '-hex', '8']);
      if (result.exitCode != 0) {
        final err = result.stderr?.toString().trim();
        throw Exception('Openssl failed (exit ${result.exitCode}): $err');
      }

      return result.stdout.toString().trim();
    } else {
      return "a1s3d18wq94${Random().nextInt(100000)}";
    }
  }

  @override
  Future<void> restartXray(List<User> users) async {
    await Future.delayed(Duration(seconds: 1));
    await _updateXrayConfig(users);
    if (Platform.isLinux) {
      final result = await Process.run('docker', [
        'compose',
        '-f',
        appConfig.pathToCompose,
        'restart',
        'xray',
      ]);

      if (result.exitCode == 0) {
        logConsole('Xray Docker has been restarted');
      } else {
        logConsole('Xray Docker error during restart');
        logConsole(result.stderr);
      }
    } else {
      logConsole("Its not linux");
    }
  }

  /// Обновляет конфиг Xray с sId пользователей
  Future<void> _updateXrayConfig(List<User> users) async {
    try {
      final configFile = File(appConfig.pathToConfig);
      if (!await configFile.exists()) {
        throw Exception(
          'Файл конфигурации не найден: ${appConfig.pathToConfig}',
        );
      }

      final configContent = await configFile.readAsString();
      final Map<String, dynamic> config = jsonDecode(configContent);

      final List<String> shortIds = users
          .where((user) => user.canAccess)
          .map((user) => user.sId)
          .toList();

      config['inbounds'][0]["streamSettings"]["realitySettings"]["shortIds"] =
          shortIds;

      final updatedConfig = const JsonEncoder.withIndent('  ').convert(config);
      await configFile.writeAsString(updatedConfig);

      logConsole('Xray config updated');
    } catch (e, st) {
      logConsole('Error with updating xray config', error: e, stackTrace: st);
      rethrow;
    }
  }
}

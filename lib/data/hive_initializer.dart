import 'dart:io';
import 'package:admin_server/models/user.dart';
import 'package:admin_server/utils/log_console.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

class HiveInitializer {
  static const String usersBoxName = 'users';

  static Future<void> init() async {
    logConsole("Initializing Hive...");
    final dir = Directory.current.path;
    final hivePath = p.join(dir, 'data', 'hive_storage');

    final Directory hiveDir = Directory(hivePath);
    if (!await hiveDir.exists()) {
      await hiveDir.create(recursive: true);
    }

    Hive.init(hivePath);

    Hive.registerAdapter(UserAdapter());
    logConsole("Hive initialized. Path: $hivePath");
  }

  static Future<Box<User>> openUsersBox() async {
    return await Hive.openBox<User>(usersBoxName);
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:admin_server/data/user_repository/user_repository.dart';
import 'package:admin_server/data/xray_repository/xray_repository.dart';
import 'package:admin_server/models/create_user.dart';
import 'package:admin_server/models/update_rules_user.dart';
import 'package:admin_server/models/user.dart';
import 'package:admin_server/utils/log_console.dart';
import 'package:hive/hive.dart';
import 'package:shelf/shelf.dart';

class AdminController {
  final UserRepository userRepository;
  final XrayRepository xrayRepository;

  const AdminController({
    required this.userRepository,
    required this.xrayRepository,
  });

  Future<Response> getUsers(Request request) async {
    logConsole("GET get users");
    try {
      final users = await userRepository.getUsers();
      return Response.ok(
        jsonEncode(users.map((u) => u.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } on HiveError catch (e, st) {
      logConsole("Error with hive", error: e, stackTrace: st);
      return Response.internalServerError(
        body: jsonEncode({'Error': 'Something happens with Hive'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> generateLink(Request request, String id) async {
    logConsole("GET generate link for user $id");
    try {
      final user = await userRepository.getUserById(id);
      if (user == null) {
        return Response.notFound(
          jsonEncode({'error': 'User not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final link = await xrayRepository.generateLink(user);
      return Response.ok(
        jsonEncode({'link': link}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      logConsole(
        "Unexpected error while generating link",
        error: e,
        stackTrace: st,
      );
      return Response.internalServerError(
        body: jsonEncode({'error': 'Internal server error'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> createUser(Request request) async {
    logConsole("POST create user");
    try {
      final body = await request.readAsString();
      final Map<String, dynamic> userData = jsonDecode(body);

      final createUser = CreateUser.fromJson(userData);
      final sId = await xrayRepository.generateSID();
      final user = User.createUser(createUser.name, sId);

      await userRepository.saveUser(user);

      return Response.ok(
        jsonEncode({'success': true, 'data': user.toJson()}),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException catch (e, st) {
      logConsole("JSON parse error", error: e, stackTrace: st);
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid format JSON'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on HiveError catch (e, st) {
      logConsole("Error with hive while saving user", error: e, stackTrace: st);
      return Response.internalServerError(
        body: jsonEncode({'error': 'Error with saving file'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      logConsole(
        "Unexpected error while saving user",
        error: e,
        stackTrace: st,
      );
      return Response.internalServerError(
        body: jsonEncode({'error': 'Internal server error'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> deleteUser(Request request, String id) async {
    logConsole("POST delete user");
    try {
      await userRepository.deleteUserById(id);

      return Response.ok(
        jsonEncode({'success': true, 'message': 'User deleted'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on HiveError catch (e, st) {
      logConsole(
        "Error with hive while deleting user",
        error: e,
        stackTrace: st,
      );
      return Response.internalServerError(
        body: jsonEncode({'error': 'Error with deleting user'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      logConsole(
        "Unexpected error while deleting user",
        error: e,
        stackTrace: st,
      );
      return Response.internalServerError(
        body: jsonEncode({'error': 'Internal server error'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> updateXray(Request request) async {
    try {
      final body = await request.readAsString();
      final List<dynamic> usersData = jsonDecode(body);
      final updateRulesUsers = usersData
          .map((data) => UpdateRulesUser.fromJson(data))
          .toList();
      final users = await userRepository.getUsers();

      for (final (index, user) in users.indexed) {
        final updatedUser = updateRulesUsers.firstWhere(
          (updateRulesUser) => updateRulesUser.id == user.id,
        );
        users[index] = users[index].copyWith(
          isPaid: updatedUser.isPaid,
          isVip: updatedUser.isVip,
        );
      }

      await userRepository.updateUsers(users);
      unawaited(xrayRepository.restartXray(users));

      return Response.ok(
        jsonEncode({'success': true, 'message': 'Xray successfully restarted'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException catch (e, st) {
      logConsole("JSON parse error", error: e, stackTrace: st);
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid format JSON'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on HiveError catch (e, st) {
      logConsole(
        "Error with hive while updating xray",
        error: e,
        stackTrace: st,
      );
      return Response.internalServerError(
        body: jsonEncode({'error': 'Internal server error'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, st) {
      logConsole(
        "Unexpected error while updating xray",
        error: e,
        stackTrace: st,
      );
      return Response.internalServerError(
        body: jsonEncode({'error': 'Internal server error'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}

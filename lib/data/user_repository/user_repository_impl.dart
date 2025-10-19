import 'package:admin_server/data/hive_initializer.dart';
import 'package:admin_server/data/user_repository/user_repository.dart';
import 'package:admin_server/models/user.dart';
import 'package:admin_server/utils/log_console.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> deleteUser(User user) async {
    final box = await HiveInitializer.openUsersBox();
    await box.delete(user.id);
    await box.close();
  }

  @override
  Future<void> deleteUserById(String id) async {
    final box = await HiveInitializer.openUsersBox();
    await box.delete(id);
    await box.close();
  }

  @override
  Future<List<User>> getUsers() async {
    final box = await HiveInitializer.openUsersBox();
    final users = box.values.toList();
    await box.close();
    return users;
  }

  @override
  Future<User?> getUserById(String id) async {
    final box = await HiveInitializer.openUsersBox();
    final user = box.get(id);
    await box.close();
    return user;
  }

  @override
  Future<void> saveUser(User user) async {
    final box = await HiveInitializer.openUsersBox();
    await box.put(user.id, user);
    await box.close();
  }

  @override
  Future<void> updateUsers(List<User> users) async {
    final box = await HiveInitializer.openUsersBox();
    for (final user in users) {
      await box.put(user.id, user);
    }
    await box.close();
  }
}

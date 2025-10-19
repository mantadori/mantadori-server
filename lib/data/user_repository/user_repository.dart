import 'package:admin_server/models/user.dart';

abstract interface class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(String id);
  Future<void> saveUser(User user);
  Future<void> deleteUser(User user);
  Future<void> deleteUserById(String id);
  Future<void> updateUsers(List<User> users);
}

import 'package:admin_server/models/user.dart';

abstract interface class XrayRepository {
  Future<String> generateSID();
  Future<void> restartXray(List<User> users);
  Future<String> generateLink(User user);
}

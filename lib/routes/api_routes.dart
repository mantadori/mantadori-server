import 'package:admin_server/controllers/admin_controller.dart';
import 'package:admin_server/di/di.dart';
import 'package:shelf_router/shelf_router.dart';

class ApiRoutes {
  final AdminController _adminController = getIt<AdminController>();

  Router get router {
    final router = Router();

    router.get('/users', _adminController.getUsers);
    router.post('/update_xray', _adminController.updateXray);
    router.post('/create_user', _adminController.createUser);
    router.delete('/delete_user/<id>', _adminController.deleteUser);
    router.get('/generate_link/<id>', _adminController.generateLink);

    return router;
  }
}

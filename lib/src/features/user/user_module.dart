import 'package:backend_flutterando/src/features/user/datasources/user_datasource.dart';
import 'package:backend_flutterando/src/features/user/datasources/user_datasource_imp.dart';
import 'package:backend_flutterando/src/features/user/repositories/user_repository.dart';
import 'package:backend_flutterando/src/features/user/resources/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<UserDataSource>((i) => UserDataSourceImp(i())),
        Bind.singleton((i) => UserRepository(i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(UserResource()),
      ];
}

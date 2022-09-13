import 'package:backend_flutterando/src/features/auth/datasources/auth_datasource.dart';
import 'package:backend_flutterando/src/features/auth/datasources/auth_datasource_imp.dart';
import 'package:backend_flutterando/src/features/auth/repositories/auth_repository.dart';
import 'package:backend_flutterando/src/features/auth/resources/auth_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthDataSource>((i) => AuthDataSourceImp(i())),
        Bind.singleton((i) => AuthRepository(i(), i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}

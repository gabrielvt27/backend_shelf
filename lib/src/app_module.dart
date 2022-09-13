import 'package:backend_flutterando/src/core/core_module.dart';
import 'package:backend_flutterando/src/features/auth/auth_module.dart';

import 'package:backend_flutterando/src/features/swagger/swagge_handler.dart';
import 'package:backend_flutterando/src/features/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Home')),
        Route.get('/documentation/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.module('/auth', module: AuthModule()),
      ];
}

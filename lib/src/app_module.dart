import 'package:backend_flutterando/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend_flutterando/src/core/services/bcrypt/bcrypt_service_imp.dart';
import 'package:backend_flutterando/src/core/services/database/postgres/postgres_database.dart';
import 'package:backend_flutterando/src/core/services/database/remote_database.dart';
import 'package:backend_flutterando/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend_flutterando/src/core/services/jwt/dart_jsonwebtoken/jwt_service_imp.dart';
import 'package:backend_flutterando/src/core/services/jwt/jwt_service.dart';
import 'package:backend_flutterando/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend_flutterando/src/features/auth/auth_resource.dart';
import 'package:backend_flutterando/src/features/swagger/swagge_handler.dart';
import 'package:backend_flutterando/src/features/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService()),
        Bind.singleton<RemoteDataBase>((i) => PostgresDatabase(i())),
        Bind.singleton<BCryptService>((i) => BCryptServiceImp()),
        Bind.singleton<JwtService>((i) => JwtServiceImp(i())),
        Bind.singleton((i) => RequestExtractor()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Home')),
        Route.get('/documentation/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.resource(AuthResource()),
      ];
}

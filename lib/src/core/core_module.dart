import 'package:shelf_modular/shelf_modular.dart';

import 'services/jwt/jwt_service.dart';
import 'services/bcrypt/bcrypt_service.dart';
import 'services/dot_env/dot_env_service.dart';
import 'services/database/remote_database.dart';
import 'services/bcrypt/bcrypt_service_imp.dart';
import 'services/request_extractor/request_extractor.dart';
import 'services/database/postgres/postgres_database.dart';
import 'services/jwt/dart_jsonwebtoken/jwt_service_imp.dart';

class CoreModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService(), export: true),
        Bind.singleton<RemoteDataBase>((i) => PostgresDatabase(i()),
            export: true),
        Bind.singleton<BCryptService>((i) => BCryptServiceImp(), export: true),
        Bind.singleton<JwtService>((i) => JwtServiceImp(i()), export: true),
        Bind.singleton((i) => RequestExtractor(), export: true),
      ];
}

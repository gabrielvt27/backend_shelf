import 'package:backend_flutterando/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend_flutterando/src/core/services/jwt/jwt_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtServiceImp implements JwtService {
  final DotEnvService dotEnvService;

  JwtServiceImp(this.dotEnvService);

  @override
  String generateToken(Map claims, String audience) {
    final jwt = JWT(claims, audience: Audience.one(audience));

    final token = jwt.sign(SecretKey(dotEnvService['JWT_KEY']!));

    return token;
  }

  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(dotEnvService['JWT_KEY']!),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );

    return jwt.payload;
  }

  @override
  void verifyToken(String token, String audience) {
    JWT.verify(
      token,
      SecretKey(dotEnvService['JWT_KEY']!),
      audience: Audience.one(audience),
    );
  }
}

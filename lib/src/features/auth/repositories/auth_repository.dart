import 'package:backend_flutterando/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend_flutterando/src/core/services/jwt/jwt_service.dart';
import 'package:backend_flutterando/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend_flutterando/src/features/auth/datasources/auth_datasource.dart';
import 'package:backend_flutterando/src/features/auth/errors/auth_exception.dart';
import 'package:backend_flutterando/src/features/auth/models/tokenization.dart';

class AuthRepository {
  final AuthDataSource authDataSource;
  final BCryptService bcrypt;
  final JwtService jwt;

  AuthRepository(this.authDataSource, this.bcrypt, this.jwt);

  Future<Tokenization> login(LoginCredential credential) async {
    var userMap = await authDataSource.getIdAndRoleByEmail(credential.email);

    if (userMap.isEmpty) {
      throw AuthException(403, 'E-mail ou senha inválida');
    }

    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      throw AuthException(403, 'E-mail ou senha inválida');
    }

    userMap = userMap..remove('password');

    return _generateToken(userMap);
  }

  Future<Tokenization> refreshToken(id) async {
    final userMap = await authDataSource.getIdAndRoleById(id);

    return _generateToken(userMap);
  }

  Future updatePassword(id, String oldPassword, String newPassword) async {
    final currentPassword = await authDataSource.getPasswordById(id);

    if (!bcrypt.checkHash(oldPassword, currentPassword)) {
      throw AuthException(403, 'Senha inválida');
    }

    await authDataSource.updatePasswordById(
      id,
      bcrypt.generateHash(newPassword),
    );
  }

  Tokenization _generateToken(Map payload) {
    payload['exp'] = _expiration(Duration(minutes: 10));

    final accessToken = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _expiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return Tokenization(accessToken: accessToken, refreshToken: refreshToken);
  }

  int _expiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }
}

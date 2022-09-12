import 'dart:convert';

import 'package:backend_flutterando/src/core/services/jwt/jwt_service.dart';
import 'package:backend_flutterando/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;
  final bool isRefreshToken;

  AuthGuard({
    this.roles = const [],
    this.isRefreshToken = false,
  });

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extractor = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(
            jsonEncode({'error': 'Not authorization header'}));
      }

      final token = extractor.getAuthorizationBearer(request);

      try {
        jwt.verifyToken(token, isRefreshToken ? 'refreshToken' : 'accessToken');

        final payload = jwt.getPayload(token);
        final role = payload['role'] ?? 'user';

        return (roles.isEmpty || roles.contains(role))
            ? handler(request)
            : Response.forbidden(
                jsonEncode({'error': 'Role ($role) not allowed'}));
      } catch (e) {
        return Response.forbidden(jsonEncode({'error': e.toString()}));
      }
    };
  }
}

import 'package:bcrypt/bcrypt.dart';

import 'package:backend_flutterando/src/core/services/bcrypt/bcrypt_service.dart';

class BCryptServiceImp implements BCryptService {
  @override
  bool checkHash(String text, String hash) => BCrypt.checkpw(text, hash);

  @override
  String generateHash(String text) => BCrypt.hashpw(text, BCrypt.gensalt());
}

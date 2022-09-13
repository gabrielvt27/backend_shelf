abstract class AuthDataSource {
  Future<Map> getIdAndRoleByEmail(String email);
  Future<Map> getIdAndRoleById(id);
  Future<String> getPasswordById(id);
  Future updatePasswordById(id, String newPassword);
}

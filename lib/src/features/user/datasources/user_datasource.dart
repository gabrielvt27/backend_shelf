abstract class UserDataSource {
  Future<List<Map<String, dynamic>?>> getAllUsers();
  Future<Map<String, dynamic>?> getUserById(id);
  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> map);
  Future<Map<String, dynamic>?> updateUser(Map<String, dynamic> map);
  Future deleteUser(id);
}

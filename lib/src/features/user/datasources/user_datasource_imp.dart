import 'package:backend_flutterando/src/core/services/database/remote_database.dart';
import 'package:backend_flutterando/src/features/user/datasources/user_datasource.dart';

class UserDataSourceImp implements UserDataSource {
  final RemoteDataBase remoteDataBase;

  UserDataSourceImp(this.remoteDataBase);

  @override
  Future<List<Map<String, dynamic>?>> getAllUsers() async {
    final result = await remoteDataBase
        .query('SELECT id, name, email, role FROM "User" ORDER BY id;');

    return result.length > 0 ? result.map((e) => e['User']).toList() : [];
  }

  @override
  Future<Map<String, dynamic>?> getUserById(id) async {
    final result = await remoteDataBase.query(
        'SELECT id, name, email, role FROM "User" WHERE id = @id;',
        variables: {
          'id': id,
        });

    return result.length > 0 ? result.map((e) => e['User']).first : null;
  }

  @override
  Future<Map<String, dynamic>?> createUser(Map<String, dynamic> map) async {
    final result = await remoteDataBase.query(
      'INSERT INTO "User"(name, email, password) VALUES (@name, @email, @password) RETURNING id, name, email, role;',
      variables: map,
    );

    return result.length > 0 ? result.map((e) => e['User']).first : null;
  }

  @override
  Future<Map<String, dynamic>?> updateUser(Map<String, dynamic> map) async {
    final inValidCols = ['id', 'password'];
    final cols = map.keys
        .where((key) => !inValidCols.contains(key))
        .map((key) => '$key=@$key')
        .toList();

    final result = await remoteDataBase.query(
      'UPDATE "User" SET ${cols.join(',')} WHERE id = @id RETURNING id, name, email, role;',
      variables: map,
    );

    return result.length > 0 ? result.map((e) => e['User']).first : null;
  }

  @override
  Future deleteUser(id) async {
    await remoteDataBase
        .query('DELETE FROM "User" WHERE id = @id;', variables: {
      'id': id,
    });
  }
}

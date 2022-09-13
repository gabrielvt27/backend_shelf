import 'package:backend_flutterando/src/core/services/database/remote_database.dart';

import 'auth_datasource.dart';

class AuthDataSourceImp extends AuthDataSource {
  final RemoteDataBase database;

  AuthDataSourceImp(this.database);

  @override
  Future<Map> getIdAndRoleByEmail(String email) async {
    final result = await database.query(
        'SELECT id, role, password FROM "User" WHERE email = @email;',
        variables: {
          'email': email,
        });

    return (result.isEmpty) ? {} : result.map((e) => e['User']).first!;
  }

  @override
  Future<Map> getIdAndRoleById(id) async {
    final result = await database.query(
      'SELECT id, role FROM "User" WHERE id = @id;',
      variables: {
        'id': id,
      },
    );

    return (result.isEmpty) ? {} : result.map((e) => e['User']).first!;
  }

  @override
  Future<String> getPasswordById(id) async {
    final result = await database
        .query('SELECT password FROM "User" WHERE id = @id;', variables: {
      'id': id,
    });

    return (result.isEmpty)
        ? ""
        : result.map((e) => e['User']).first!['password'];
  }

  @override
  Future updatePasswordById(id, String newPassword) async {
    await database.query('UPDATE "User" SET password=@password WHERE id = @id;',
        variables: {
          'id': id,
          'password': newPassword,
        });
  }
}

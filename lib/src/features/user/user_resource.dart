import 'dart:async';
import 'dart:convert';

import 'package:backend_flutterando/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend_flutterando/src/core/services/database/remote_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUsers),
        Route.get('/user/:id', _getUserById),
        Route.post('/user', _createUser),
        Route.put('/user/:id', _updateUser),
        Route.delete('/user/:id', _deleteUser),
      ];

  FutureOr<Response> _getAllUsers(Injector injector) async {
    final database = injector.get<RemoteDataBase>();

    final result = await database
        .query('SELECT id, name, email, role FROM "User" ORDER BY id;');

    final usersList = result.map((e) => e['User']).toList();
    return Response.ok(jsonEncode(usersList));
  }

  FutureOr<Response> _getUserById(
      ModularArguments arguments, Injector injector) async {
    final userId = arguments.params['id'];
    final database = injector.get<RemoteDataBase>();

    final result = await database.query(
        'SELECT id, name, email, role FROM "User" WHERE id = @id;',
        variables: {
          'id': userId,
        });

    final userMap = result.map((e) => e['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _createUser(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    final database = injector.get<RemoteDataBase>();
    final bcrypt = injector.get<BCryptService>();

    userParams.remove('id');
    userParams['password'] =
        bcrypt.generateHash(userParams['password'].toString());

    final result = await database.query(
      'INSERT INTO "User"(name, email, password) VALUES (@name, @email, @password) RETURNING id, name, email, role;',
      variables: userParams,
    );

    final userMap = result.map((e) => e['User']).first;
    return Response(201, body: jsonEncode(userMap));
  }

  FutureOr<Response> _updateUser(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    final inValidCols = ['id', 'password'];
    final cols = userParams.keys
        .where((key) => !inValidCols.contains(key))
        .map((key) => '$key=@$key')
        .toList();

    final database = injector.get<RemoteDataBase>();

    final result = await database.query(
      'UPDATE "User" SET ${cols.join(',')} WHERE id = @id RETURNING id, name, email, role;',
      variables: userParams,
    );

    final userMap = result.map((e) => e['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _deleteUser(
      ModularArguments arguments, Injector injector) async {
    final userId = arguments.params['id'];
    final database = injector.get<RemoteDataBase>();

    await database.query('DELETE FROM "User" WHERE id = @id;', variables: {
      'id': userId,
    });

    return Response.ok(jsonEncode({"message": "deleted $userId"}));
  }
}

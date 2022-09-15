import 'dart:async';
import 'dart:convert';

import 'package:backend_flutterando/src/core/services/database/remote_database.dart';
import 'package:backend_flutterando/src/features/auth/guard/auth_guard.dart';
import 'package:backend_flutterando/src/features/user/errors/user_exception.dart';
import 'package:backend_flutterando/src/features/user/models/userparams_model.dart';
import 'package:backend_flutterando/src/features/user/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', _getAllUsers, middlewares: [AuthGuard()]),
        Route.get('/:id', _getUserById, middlewares: [AuthGuard()]),
        Route.post('/', _createUser),
        Route.put('/', _updateUser, middlewares: [AuthGuard()]),
        Route.delete('/:id', _deleteUser, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _getAllUsers(Injector injector) async {
    final userRepository = injector.get<UserRepository>();
    final userList = await userRepository.getAllUsers();
    return Response.ok(
      jsonEncode(userList.map((user) => user.toMap()).toList()),
    );
  }

  FutureOr<Response> _getUserById(
      ModularArguments arguments, Injector injector) async {
    final userId = arguments.params['id'];
    final userRepository = injector.get<UserRepository>();

    try {
      final user = await userRepository.getUserById(userId);
      return Response.ok(user.toJson());
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _createUser(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data as Map).cast<String, dynamic>();
    final userRepository = injector.get<UserRepository>();

    try {
      final user =
          await userRepository.createUser(UserParamsModel.fromMap(userParams));
      return Response.ok(user.toJson());
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _updateUser(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data as Map).cast<String, dynamic>();
    final userRepository = injector.get<UserRepository>();

    try {
      final user =
          await userRepository.updateUser(UserParamsModel.fromMap(userParams));
      return Response.ok(user.toJson());
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _deleteUser(
      ModularArguments arguments, Injector injector) async {
    final userId = arguments.params['id'];
    final userRepository = injector.get<UserRepository>();

    await userRepository.deleteUser(userId);

    return Response.ok(jsonEncode({"message": "deleted $userId"}));
  }
}

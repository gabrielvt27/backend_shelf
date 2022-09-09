import 'dart:async';

import 'package:backend_flutterando/src/core/services/database/remote_database.dart';
import 'package:backend_flutterando/src/core/services/dot_env/dot_env_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';

class PostgresDatabase implements RemoteDataBase, Disposable {
  final completer = Completer<PostgreSQLConnection>();
  final DotEnvService dotEnvService;

  PostgresDatabase(this.dotEnvService) {
    _init();
  }

  _init() async {
    final url = dotEnvService['DATABASE_URL']!;

    final uri = Uri.parse(url);

    var connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
    );

    await connection.open();
    completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  }) async {
    final connection = await completer.future;

    return connection.mappedResultsQuery(
      queryText,
      substitutionValues: variables,
    );
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    connection.close();
  }
}

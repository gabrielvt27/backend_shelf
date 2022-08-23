import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:backend_flutterando/src/app_module.dart';

Future<Handler> startShelfModular() async {
  return await Modular(
    module: AppModule(),
    middlewares: [
      logRequests(), // Middleware Pipeline
    ],
  );
}

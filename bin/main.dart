import 'package:backend_flutterando/backend.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final modularHandler = await startShelfModular();
  final server = await io.serve(modularHandler, '127.0.0.1', 3000);

  print('Server iniciado em http://${server.address.address}:${server.port}');
}

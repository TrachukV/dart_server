import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'database.dart';

void main() async {
  final database = DatabaseHelper();
  await database.open();

  final app = Router();

  app.get('/file/<filename>', (Request request, String filename) async {
    final fileBytes = await database.getFileBytesFromDatabase(filename);

    if (fileBytes != null) {
      return Response.ok(fileBytes,
          headers: {'Content-Type': 'application/octet-stream'});
    } else {
      return Response.notFound('File not found');
    }
  });

  app.get('/getjson', (Request request) {
    final jsonData = {
      'message': 'test request',
      'timestamp': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

    final jsonString = json.encode(jsonData);

    return Response.ok(jsonString,
        headers: {'Content-Type': 'application/json'});
  });

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  final server = await serve(handler, '0.0.0.0', 8080);
  print('Server on http://${server.address.host}:${server.port}');
}

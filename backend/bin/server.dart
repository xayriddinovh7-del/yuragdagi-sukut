import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:aytilmagan_gaplar_backend/routes/book_routes.dart';
import 'package:aytilmagan_gaplar_backend/routes/health_routes.dart';
import 'package:aytilmagan_gaplar_backend/middleware/cors_middleware.dart';

void main(List<String> args) async {
  // Use port from environment or default to 8080
  final portStr = Platform.environment['PORT'] ?? '8080';
  final port = int.tryParse(portStr) ?? 8080;

  // Use ip from environment or bind to all interfaces
  final ip = InternetAddress.anyIPv4;

  // Initialise Routers
  final router = Router();
  
  // Register Mount routes
  router.mount('/api', BookRoutes().router.call);
  router.mount('/', HealthRoutes().router.call);

  // Define full Pipeline with logging and custom CORS middleware
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  // Bind server
  final server = await io.serve(handler, ip, port);
  stdout.writeln('🚀 Server is running perfectly at http://${server.address.host}:${server.port}');
  stdout.writeln('📚 Health endpoint available at http://${server.address.host}:${server.port}/health');
  stdout.writeln('📖 Book API available at http://${server.address.host}:${server.port}/api/books');
}

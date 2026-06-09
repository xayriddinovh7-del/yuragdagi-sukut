import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/api_response.dart';

class HealthRoutes {
  Router get router {
    final router = Router();

    // GET /health - Check system status
    router.get('/health', (Request request) {
      final info = {
        'status': 'healthy',
        'timestamp': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'service': 'Aytilmagan Gaplar Backend API',
      };
      
      return Response.ok(
        ApiResponse(success: true, data: info, message: 'Server is running perfectly.').toString(),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}

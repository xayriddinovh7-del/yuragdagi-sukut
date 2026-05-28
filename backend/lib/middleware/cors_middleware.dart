import 'package:shelf/shelf.dart';

/// Middleware to add robust CORS headers to every HTTP response.
Middleware corsMiddleware() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
  };

  return (Handler innerHandler) {
    return (Request request) async {
      // Handle preflight OPTIONS requests directly
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }

      final response = await innerHandler(request);
      
      // Merge CORS headers with the existing headers in response
      final newHeaders = Map<String, String>.from(response.headers)..addAll(corsHeaders);
      
      return response.change(headers: newHeaders);
    };
  };
}

import 'package:shelf/shelf.dart';

/// CORS Middleware — yurakdaagi-sukut.com domeniga ruxsat beradi.
///
/// Ruxsat berilgan manbalar:
///   https://yurakdaagi-sukut.com
///   https://www.yurakdaagi-sukut.com
///   http://localhost (development uchun)
Middleware corsMiddleware() {
  const allowedOrigins = [
    'https://yurakdaagi-sukut.com',
    'https://www.yurakdaagi-sukut.com',
    'http://localhost',
    'http://localhost:3000',
    'http://localhost:8080',
  ];

  Map<String, String> corsHeaders(String origin) => {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers':
        'Origin, X-Requested-With, Content-Type, Accept, Authorization',
    'Access-Control-Allow-Credentials': 'true',
    'Vary': 'Origin',
  };

  return (Handler innerHandler) {
    return (Request request) async {
      final origin = request.headers['origin'] ?? '';
      final isAllowed = allowedOrigins.any((o) => origin.startsWith(o));
      final responseOrigin = isAllowed ? origin : allowedOrigins.first;

      // Preflight OPTIONS so'rovlarini to'g'ridan-to'g'ri qaytarish
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders(responseOrigin));
      }

      final response = await innerHandler(request);
      final newHeaders = Map<String, String>.from(response.headers)
        ..addAll(corsHeaders(responseOrigin));

      return response.change(headers: newHeaders);
    };
  };
}

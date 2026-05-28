import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../data/book_content.dart';
import '../models/api_response.dart';

class BookRoutes {
  Router get router {
    final router = Router();

    // GET /api/books - Get general metadata of the book
    router.get('/books', (Request request) {
      final data = {
        'title': BookContent.title,
        'author': BookContent.author,
        'description': BookContent.description,
        'chapterCount': BookContent.chapters.length,
      };
      
      return Response.ok(
        ApiResponse(success: true, data: data).toString(),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /api/books/chapters - List chapters without the huge text content
    router.get('/books/chapters', (Request request) {
      final list = BookContent.chapters.map((ch) {
        final json = ch.toJson();
        json.remove('content'); // remove heavy content for listing
        return json;
      }).toList();

      return Response.ok(
        ApiResponse(success: true, data: list).toString(),
        headers: {'Content-Type': 'application/json'},
      );
    });

    // GET /api/books/chapters/<id> - Get single chapter detail with content
    router.get('/books/chapters/<id>', (Request request, String id) {
      final index = int.tryParse(id);
      if (index == null || index < 0 || index >= BookContent.chapters.length) {
        return Response.notFound(
          ApiResponse(success: false, message: 'Chapter not found').toString(),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final chapter = BookContent.chapters[index];
      return Response.ok(
        ApiResponse(success: true, data: chapter.toJson()).toString(),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}

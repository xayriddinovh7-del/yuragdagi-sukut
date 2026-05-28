import 'dart:convert';

/// Standardised API response wrapper to ensure consistent client-side parsing.
class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
  });

  Map<String, dynamic> toJson() => {
        'success': success,
        if (message != null) 'message': message,
        if (data != null) 'data': data,
        if (meta != null) 'meta': meta,
      };

  @override
  String toString() => jsonEncode(toJson());
}

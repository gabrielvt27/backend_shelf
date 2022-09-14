import 'dart:convert';

class UserException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int statusCode;

  UserException(this.statusCode, this.message, [this.stackTrace]);

  @override
  String toString() =>
      'AuthException(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';

  String toJson() => jsonEncode({'error': message});
}

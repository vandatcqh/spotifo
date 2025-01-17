class ServerException implements Exception {
  final String message;

  ServerException({required this.message});

  @override
  // ignore: unnecessary_string_interpolations
  String toString() => '$message';
}

class ApiException implements Exception {
  const ApiException(this.message, {this.path, this.statusCode});

  final String message;
  final String? path;
  final int? statusCode;

  @override
  String toString() => 'ApiException(${statusCode ?? '-'}) $path: $message';
}

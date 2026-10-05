class ApiResponse {
  const ApiResponse({required this.statusCode, this.body});

  final int statusCode;
  final Object? body;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}

import 'api_response.dart';

abstract interface class ApiClient {
  Future<ApiResponse> get(String path, {Map<String, String>? query});

  Future<ApiResponse> post(String path, {Object? body});
}

class FakeApiClient implements ApiClient {
  FakeApiClient({
    Map<String, Object?>? routes,
    this.latency = const Duration(milliseconds: 250),
  }) : _routes = {...?routes};

  final Map<String, Object?> _routes;
  final Duration latency;

  void register(String path, Object? response) => _routes[path] = response;

  @override
  Future<ApiResponse> get(String path, {Map<String, String>? query}) async {
    await Future<void>.delayed(latency);
    if (!_routes.containsKey(path)) {
      return ApiResponse(
        statusCode: 404,
        body: {'message': 'Not found: $path'},
      );
    }
    return ApiResponse(statusCode: 200, body: _resolve(path, query));
  }

  @override
  Future<ApiResponse> post(String path, {Object? body}) async {
    await Future<void>.delayed(latency);
    if (!_routes.containsKey(path)) {
      return ApiResponse(statusCode: 201, body: body);
    }
    return ApiResponse(statusCode: 200, body: _resolve(path, body));
  }

  Object? _resolve(String path, Object? input) {
    final route = _routes[path];
    if (route is Object? Function(Object?)) {
      return route(input);
    }
    return route;
  }
}

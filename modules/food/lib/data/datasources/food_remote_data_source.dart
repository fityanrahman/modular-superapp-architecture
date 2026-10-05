import 'package:core/core.dart';

abstract interface class FoodRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchRestaurants();

  Future<Map<String, dynamic>> fetchRestaurant(String id);

  Future<List<Map<String, dynamic>>> fetchMenu(String restaurantId);

  Future<Map<String, dynamic>> submitOrder(Map<String, dynamic> payload);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  FoodRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<Map<String, dynamic>>> fetchRestaurants() async {
    const path = '/food/restaurants';
    final ApiResponse response = await _apiClient.get(path);
    return _asList(response, path);
  }

  @override
  Future<Map<String, dynamic>> fetchRestaurant(String id) async {
    final String path = '/food/restaurants/$id';
    final ApiResponse response = await _apiClient.get(path);
    return _asMap(response, path);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMenu(String restaurantId) async {
    final String path = '/food/restaurants/$restaurantId/menu';
    final ApiResponse response = await _apiClient.get(path);
    return _asList(response, path);
  }

  @override
  Future<Map<String, dynamic>> submitOrder(Map<String, dynamic> payload) async {
    const path = '/food/orders';
    final ApiResponse response = await _apiClient.post(path, body: payload);
    return _asMap(response, path);
  }

  List<Map<String, dynamic>> _asList(ApiResponse response, String path) {
    if (!response.isSuccessful) {
      throw ApiException(
        'Failed to load $path',
        path: path,
        statusCode: response.statusCode,
      );
    }
    return (response.body as List).cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> _asMap(ApiResponse response, String path) {
    if (!response.isSuccessful) {
      throw ApiException(
        'Request failed for $path',
        path: path,
        statusCode: response.statusCode,
      );
    }
    return (response.body as Map).cast<String, dynamic>();
  }
}

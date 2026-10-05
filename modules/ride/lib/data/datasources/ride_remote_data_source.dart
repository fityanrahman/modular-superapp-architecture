import 'package:core/core.dart';

abstract interface class RideRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchDestinations();
}

class RideRemoteDataSourceImpl implements RideRemoteDataSource {
  RideRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    const path = '/ride/destinations';
    final ApiResponse response = await _apiClient.get(path);
    if (!response.isSuccessful) {
      throw ApiException(
        'Failed to load $path',
        path: path,
        statusCode: response.statusCode,
      );
    }
    return (response.body as List).cast<Map<String, dynamic>>();
  }
}

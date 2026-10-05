import 'package:core/core.dart';

abstract interface class WalletRemoteDataSource {
  Future<Map<String, dynamic>> fetchAccount();

  Future<List<Map<String, dynamic>>> fetchTransactions();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> fetchAccount() async {
    const path = '/wallet/balance';
    final ApiResponse response = await _apiClient.get(path);
    return _asMap(response, path);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    const path = '/wallet/transactions';
    final ApiResponse response = await _apiClient.get(path);
    return _asList(response, path);
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

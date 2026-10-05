import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeApiClient', () {
    test('returns the registered route body', () async {
      final client = FakeApiClient(
        routes: {
          '/ping': {'ok': true},
        },
        latency: Duration.zero,
      );

      final response = await client.get('/ping');

      expect(response.isSuccessful, isTrue);
      expect(response.body, {'ok': true});
    });

    test('returns 404 for an unknown route', () async {
      final client = FakeApiClient(latency: Duration.zero);

      final response = await client.get('/missing');

      expect(response.statusCode, 404);
    });

    test('resolves a dynamic route handler', () async {
      final client = FakeApiClient(
        routes: {
          '/echo': (Object? input) => {'echo': input},
        },
        latency: Duration.zero,
      );

      final response = await client.post('/echo', body: {'amount': 10});

      expect(response.body, {
        'echo': {'amount': 10},
      });
    });
  });

  test('AppConfig.development is not production', () {
    const config = AppConfig.development();

    expect(config.isProduction, isFalse);
    expect(config.enableAnalytics, isFalse);
  });
}

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food/food.dart';
import 'package:food_dev_app/main.dart';
import 'package:food_dev_app/mock/mock_payment_launcher.dart';

void main() {
  test('mock payment launcher succeeds by default', () async {
    const MockPaymentLauncher launcher = MockPaymentLauncher(
      delay: Duration.zero,
    );

    final result = await launcher.pay(amount: 25000);

    expect(result.success, isTrue);
    expect(result.transactionId, isNotNull);
  });

  test('mock payment launcher can be configured to fail', () async {
    const MockPaymentLauncher launcher = MockPaymentLauncher(
      shouldSucceed: false,
      delay: Duration.zero,
    );

    final result = await launcher.pay(amount: 25000);

    expect(result.success, isFalse);
    expect(result.message, 'Mock payment declined');
  });

  testWidgets('food dev app hosts the Food module without the Wallet module', (
    WidgetTester tester,
  ) async {
    final FoodModule foodModule = FoodModule(
      apiClient: FakeApiClient(
        routes: foodMockRoutes(),
        latency: Duration.zero,
      ),
      paymentLauncher: const MockPaymentLauncher(delay: Duration.zero),
    );

    await tester.pumpWidget(FoodDevApp(foodModule: foodModule));
    await tester.pumpAndSettle();

    expect(find.text('Food'), findsWidgets);
    expect(find.text('Nusantara Kitchen'), findsOneWidget);
  });
}

import 'package:consumer_app/app/composition_root.dart';
import 'package:consumer_app/app/consumer_app.dart';
import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food/food.dart';
import 'package:ride/ride.dart';
import 'package:wallet/wallet.dart';

Map<String, Object?> _mockRoutes() => <String, Object?>{
  ...rideMockRoutes(),
  ...foodMockRoutes(),
  ...walletMockRoutes(),
};

void main() {
  test('composition root wires the ride, food and wallet modules', () {
    final AppCompositionRoot root = AppCompositionRoot(
      config: const AppConfig.development(),
      apiClient: FakeApiClient(routes: _mockRoutes(), latency: Duration.zero),
    );

    expect(root.modules.map((module) => module.moduleId).toList(), <String>[
      'ride',
      'food',
      'wallet',
    ]);
  });

  testWidgets('the application shell lists every module', (tester) async {
    final AppCompositionRoot root = AppCompositionRoot(
      config: const AppConfig.development(),
      apiClient: FakeApiClient(routes: _mockRoutes(), latency: Duration.zero),
    );

    await tester.pumpWidget(ConsumerApp(compositionRoot: root));
    await tester.pumpAndSettle();

    expect(find.text('SuperApp'), findsOneWidget);
    expect(find.text('Ride'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
  });

  testWidgets(
    'payments through the PaymentLauncher contract are visible in the Wallet UI',
    (WidgetTester tester) async {
      final FakeApiClient apiClient = FakeApiClient(
        routes: _mockRoutes(),
        latency: Duration.zero,
      );
      final WalletModule wallet = WalletModule(apiClient: apiClient);

      final PaymentResult? result = await tester.runAsync(
        () => wallet.paymentLauncher.pay(
          amount: 50000,
          description: 'Food order',
        ),
      );
      expect(result!.success, isTrue);
      expect(result.transactionId, isNotNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(builder: (context) => wallet.buildRoot(context)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rp 200.000'), findsOneWidget);
    },
  );
}

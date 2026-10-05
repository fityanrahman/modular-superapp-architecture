import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/wallet.dart';
import 'package:wallet_dev_app/main.dart';

void main() {
  testWidgets('wallet dev app hosts the Wallet module',
      (WidgetTester tester) async {
    final WalletModule walletModule = WalletModule(
      apiClient: FakeApiClient(
        routes: walletMockRoutes(),
        latency: Duration.zero,
      ),
    );

    await tester.pumpWidget(WalletDevApp(walletModule: walletModule));
    await tester.pumpAndSettle();

    expect(find.text('Wallet'), findsWidgets);
    expect(find.text('Rp 250.000'), findsOneWidget);
  });
}

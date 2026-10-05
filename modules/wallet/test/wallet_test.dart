import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/contracts/wallet_payment_launcher.dart';
import 'package:wallet/data/datasources/wallet_fixtures.dart';
import 'package:wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:wallet/data/repositories/wallet_repository_impl.dart';
import 'package:wallet/domain/entities/wallet_account.dart';

void main() {
  late WalletRepositoryImpl repository;

  setUp(() {
    final FakeApiClient client = FakeApiClient(
      routes: walletMockRoutes(),
      latency: Duration.zero,
    );
    repository = WalletRepositoryImpl(WalletRemoteDataSourceImpl(client));
  });

  test('loads the wallet account with the mock balance', () async {
    final WalletAccount account = await repository.getAccount();

    expect(account.balance, 250000);
    expect(account.currency, 'IDR');
  });

  test('pays and deducts the balance', () async {
    final PaymentResult result = await repository.pay(
      amount: 100000,
      description: 'Test payment',
    );

    expect(result.success, isTrue);
    expect(result.transactionId, isNotNull);

    final WalletAccount account = await repository.getAccount();
    expect(account.balance, 150000);
  });

  test('fails to pay when the balance is insufficient', () async {
    final PaymentResult result = await repository.pay(amount: 1000000);

    expect(result.success, isFalse);
    expect(result.message, 'Insufficient balance');
  });

  test('tops up the wallet balance', () async {
    final WalletAccount account = await repository.topUp(50000);

    expect(account.balance, 300000);
  });

  test('payment launcher returns a successful result', () async {
    final WalletPaymentLauncher launcher = WalletPaymentLauncher(repository);

    final PaymentResult result = await launcher.pay(amount: 25000);

    expect(result.success, isTrue);
    expect(result.transactionId, isNotNull);
  });
}

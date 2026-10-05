import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../data/datasources/wallet_remote_data_source.dart';
import '../data/repositories/wallet_repository_impl.dart';
import '../domain/repositories/wallet_repository.dart';
import '../domain/usecases/get_transactions.dart';
import '../domain/usecases/get_wallet_account.dart';
import '../domain/usecases/make_payment.dart';
import '../domain/usecases/top_up.dart';
import '../presentation/wallet_dependencies.dart';
import '../presentation/wallet_flow.dart';
import 'wallet_payment_launcher.dart';

class WalletModule implements ModuleLauncher {
  WalletModule({
    required ApiClient apiClient,
    AnalyticsService? analytics,
    AppLogger? logger,
  })  : _analytics = analytics ?? const NoopAnalyticsService(),
        _logger = logger ?? AppLogger(tag: 'Wallet') {
    final WalletRepository repository = WalletRepositoryImpl(
      WalletRemoteDataSourceImpl(apiClient),
    );
    _repository = repository;
    _paymentLauncher = WalletPaymentLauncher(_repository);

    _dependencies = WalletDependencies(
      getWalletAccount: GetWalletAccount(repository),
      getTransactions: GetTransactions(repository),
      makePayment: MakePayment(repository),
      topUp: TopUp(repository),
      analytics: _analytics,
      logger: _logger,
    );

    _logger.info('Wallet module initialised');
  }

  final AnalyticsService _analytics;
  final AppLogger _logger;
  late final WalletRepository _repository;
  late final WalletDependencies _dependencies;
  late final PaymentLauncher _paymentLauncher;

  @override
  String get moduleId => 'wallet';

  @override
  String get title => 'Wallet';

  @override
  IconData get icon => Icons.account_balance_wallet;

  PaymentLauncher get paymentLauncher => _paymentLauncher;

  @override
  Widget buildRoot(BuildContext context) =>
      WalletFlow(dependencies: _dependencies);
}

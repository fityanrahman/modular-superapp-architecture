import 'package:core/core.dart';

import '../domain/usecases/get_transactions.dart';
import '../domain/usecases/get_wallet_account.dart';
import '../domain/usecases/make_payment.dart';
import '../domain/usecases/top_up.dart';

class WalletDependencies {
  const WalletDependencies({
    required this.getWalletAccount,
    required this.getTransactions,
    required this.makePayment,
    required this.topUp,
    required this.analytics,
    required this.logger,
  });

  final GetWalletAccount getWalletAccount;
  final GetTransactions getTransactions;
  final MakePayment makePayment;
  final TopUp topUp;
  final AnalyticsService analytics;
  final AppLogger logger;
}

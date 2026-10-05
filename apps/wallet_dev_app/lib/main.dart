import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:wallet/wallet.dart';

void main() {
  final WalletModule walletModule = WalletModule(
    apiClient: FakeApiClient(routes: walletMockRoutes()),
    logger: AppLogger(tag: 'WalletDevApp'),
  );

  runApp(WalletDevApp(walletModule: walletModule));
}

class WalletDevApp extends StatelessWidget {
  const WalletDevApp({super.key, required this.walletModule});

  final WalletModule walletModule;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Dev App',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: walletModule.buildRoot(context),
    );
  }
}

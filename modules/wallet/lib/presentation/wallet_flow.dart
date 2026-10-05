import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/wallet_cubit.dart';
import 'pages/wallet_home_page.dart';
import 'wallet_dependencies.dart';

class WalletFlow extends StatefulWidget {
  const WalletFlow({super.key, required this.dependencies});

  final WalletDependencies dependencies;

  @override
  State<WalletFlow> createState() => _WalletFlowState();
}

class _WalletFlowState extends State<WalletFlow> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletCubit>(
      create: (_) => WalletCubit(
        getWalletAccount: widget.dependencies.getWalletAccount,
        getTransactions: widget.dependencies.getTransactions,
        topUp: widget.dependencies.topUp,
      )..load(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          final NavigatorState? nested = _navigatorKey.currentState;
          if (nested != null && nested.canPop()) {
            nested.pop();
          } else {
            Navigator.of(context, rootNavigator: true).maybePop();
          }
        },
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => WalletHomePage(dependencies: widget.dependencies),
          ),
        ),
      ),
    );
  }
}

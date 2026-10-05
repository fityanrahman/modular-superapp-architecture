import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'food_dependencies.dart';
import 'bloc/cart_cubit.dart';
import 'pages/food_home_page.dart';

class FoodFlow extends StatefulWidget {
  const FoodFlow({super.key, required this.dependencies});

  final FoodDependencies dependencies;

  @override
  State<FoodFlow> createState() => _FoodFlowState();
}

class _FoodFlowState extends State<FoodFlow> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (_) => CartCubit(),
      child: NavigatorPopHandler(
        onPopWithResult: (_) => _navigatorKey.currentState?.pop(),
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => FoodHomePage(dependencies: widget.dependencies),
          ),
        ),
      ),
    );
  }
}

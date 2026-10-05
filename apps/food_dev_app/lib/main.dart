import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:food/food.dart';

import 'mock/mock_payment_launcher.dart';

void main() {
  final FoodModule foodModule = FoodModule(
    apiClient: FakeApiClient(routes: foodMockRoutes()),
    paymentLauncher: const MockPaymentLauncher(),
    logger: AppLogger(tag: 'FoodDevApp'),
  );

  runApp(FoodDevApp(foodModule: foodModule));
}

class FoodDevApp extends StatelessWidget {
  const FoodDevApp({super.key, required this.foodModule});

  final FoodModule foodModule;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Dev App',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: foodModule.buildRoot(context),
    );
  }
}

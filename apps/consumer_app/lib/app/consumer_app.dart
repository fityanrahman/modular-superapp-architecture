import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'composition_root.dart';
import 'home_page.dart';

class ConsumerApp extends StatelessWidget {
  const ConsumerApp({super.key, required this.compositionRoot});

  final AppCompositionRoot compositionRoot;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: compositionRoot.config.appName,
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: SuperAppHomePage(
        modules: compositionRoot.modules,
        environment: compositionRoot.config.environment.name,
      ),
    );
  }
}

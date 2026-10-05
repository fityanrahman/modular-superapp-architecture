import 'package:contracts/contracts.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SuperAppHomePage extends StatelessWidget {
  const SuperAppHomePage({
    super.key,
    required this.modules,
    required this.environment,
  });

  final List<ModuleLauncher> modules;
  final String environment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperApp'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                environment.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ModuleLauncher module = modules[index];
          return AppCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => module.buildRoot(context),
              ),
            ),
            child: Row(
              children: [
                Icon(module.icon, size: 28, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(module.title, style: AppTypography.title),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          );
        },
      ),
    );
  }
}

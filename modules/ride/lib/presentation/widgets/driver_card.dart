import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/driver.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({super.key, required this.driver});

  final Driver driver;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driver.name, style: AppTypography.title),
                const SizedBox(height: 4),
                Text(
                  '${driver.vehicle} · ${driver.plateNumber}',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: 4),
                Text('${driver.rating} ★', style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

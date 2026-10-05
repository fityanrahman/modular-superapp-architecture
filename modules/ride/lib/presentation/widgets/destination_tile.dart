import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/ride_location.dart';

class DestinationTile extends StatelessWidget {
  const DestinationTile({
    super.key,
    required this.destination,
    required this.onRequest,
  });

  final RideLocation destination;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.place_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name, style: AppTypography.title),
                const SizedBox(height: 4),
                Text(destination.address, style: AppTypography.caption),
                const SizedBox(height: 6),
                Text(
                  formatRupiah(destination.estimatedFare),
                  style: AppTypography.body,
                ),
              ],
            ),
          ),
          TextButton(onPressed: onRequest, child: const Text('Request')),
        ],
      ),
    );
  }
}

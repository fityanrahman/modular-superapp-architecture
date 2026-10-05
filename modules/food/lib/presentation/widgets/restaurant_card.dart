import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  final Restaurant restaurant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Text(restaurant.imageEmoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant.name, style: AppTypography.title),
                const SizedBox(height: 4),
                Text(
                  '${restaurant.cuisine} · ${restaurant.rating} ★',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: 4),
                Text(
                  '${restaurant.deliveryEtaMinutes} min delivery',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

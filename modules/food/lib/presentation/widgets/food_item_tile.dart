import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/food_item.dart';

class FoodItemTile extends StatelessWidget {
  const FoodItemTile({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final FoodItem item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Text(item.imageEmoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTypography.title),
                const SizedBox(height: 4),
                Text(item.description, style: AppTypography.caption),
                const SizedBox(height: 6),
                Text(formatRupiah(item.price), style: AppTypography.body),
              ],
            ),
          ),
          if (quantity == 0)
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
            )
          else
            Row(
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$quantity', style: AppTypography.title),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

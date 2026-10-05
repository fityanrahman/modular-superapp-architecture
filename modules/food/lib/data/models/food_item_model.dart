import '../../domain/entities/food_item.dart';

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageEmoji,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) => FoodItemModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    imageEmoji: json['imageEmoji'] as String? ?? '🍽️',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageEmoji': imageEmoji,
  };
}

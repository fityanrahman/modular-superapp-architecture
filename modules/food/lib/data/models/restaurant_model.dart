import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.cuisine,
    required super.rating,
    required super.deliveryEtaMinutes,
    super.imageEmoji,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
        id: json['id'] as String,
        name: json['name'] as String,
        cuisine: json['cuisine'] as String,
        rating: (json['rating'] as num).toDouble(),
        deliveryEtaMinutes: (json['deliveryEtaMinutes'] as num).toInt(),
        imageEmoji: json['imageEmoji'] as String? ?? '🍜',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cuisine': cuisine,
        'rating': rating,
        'deliveryEtaMinutes': deliveryEtaMinutes,
        'imageEmoji': imageEmoji,
      };
}

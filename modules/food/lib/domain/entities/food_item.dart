import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageEmoji = '🍽️',
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageEmoji;

  @override
  List<Object?> get props => [id, name, description, price, imageEmoji];
}

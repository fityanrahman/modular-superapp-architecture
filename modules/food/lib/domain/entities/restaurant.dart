import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryEtaMinutes,
    this.imageEmoji = '🍜',
  });

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final int deliveryEtaMinutes;
  final String imageEmoji;

  @override
  List<Object?> get props => [
    id,
    name,
    cuisine,
    rating,
    deliveryEtaMinutes,
    imageEmoji,
  ];
}

import '../../domain/entities/ride_location.dart';

class RideLocationModel extends RideLocation {
  const RideLocationModel({
    required super.name,
    required super.address,
    required super.estimatedFare,
  });

  factory RideLocationModel.fromJson(Map<String, dynamic> json) =>
      RideLocationModel(
        name: json['name'] as String,
        address: json['address'] as String,
        estimatedFare: (json['estimatedFare'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'estimatedFare': estimatedFare,
  };
}

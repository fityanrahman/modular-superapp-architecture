const List<Map<String, Object?>> _restaurants = [
  {
    'id': 'r1',
    'name': 'Nusantara Kitchen',
    'cuisine': 'Indonesian',
    'rating': 4.8,
    'deliveryEtaMinutes': 25,
    'imageEmoji': '🍛',
  },
  {
    'id': 'r2',
    'name': 'Sakura Sushi',
    'cuisine': 'Japanese',
    'rating': 4.6,
    'deliveryEtaMinutes': 35,
    'imageEmoji': '🍣',
  },
  {
    'id': 'r3',
    'name': 'Burger Lab',
    'cuisine': 'Western',
    'rating': 4.4,
    'deliveryEtaMinutes': 20,
    'imageEmoji': '🍔',
  },
];

const Map<String, List<Map<String, Object?>>> _menu = {
  'r1': [
    {
      'id': 'r1-m1',
      'name': 'Nasi Goreng Special',
      'description': 'Fried rice with chicken satay and a fried egg.',
      'price': 28000.0,
      'imageEmoji': '🍚',
    },
    {
      'id': 'r1-m2',
      'name': 'Sate Ayam',
      'description': 'Grilled chicken skewers with peanut sauce.',
      'price': 32000.0,
      'imageEmoji': '🍢',
    },
    {
      'id': 'r1-m3',
      'name': 'Es Teh Manis',
      'description': 'Sweet iced tea.',
      'price': 8000.0,
      'imageEmoji': '🧋',
    },
  ],
  'r2': [
    {
      'id': 'r2-m1',
      'name': 'Salmon Nigiri',
      'description': 'Two pieces of fresh salmon over rice.',
      'price': 45000.0,
      'imageEmoji': '🍣',
    },
    {
      'id': 'r2-m2',
      'name': 'Chicken Katsu Roll',
      'description': 'Crispy chicken katsu roll with teriyaki.',
      'price': 52000.0,
      'imageEmoji': '🍱',
    },
    {
      'id': 'r2-m3',
      'name': 'Miso Soup',
      'description': 'Warm soybean paste soup.',
      'price': 18000.0,
      'imageEmoji': '🍲',
    },
  ],
  'r3': [
    {
      'id': 'r3-m1',
      'name': 'Classic Cheeseburger',
      'description': 'Beef patty, cheddar, lettuce and tomato.',
      'price': 42000.0,
      'imageEmoji': '🍔',
    },
    {
      'id': 'r3-m2',
      'name': 'Truffle Fries',
      'description': 'Hand-cut fries with truffle oil.',
      'price': 26000.0,
      'imageEmoji': '🍟',
    },
    {
      'id': 'r3-m3',
      'name': 'Chocolate Milkshake',
      'description': 'Thick chocolate milkshake.',
      'price': 30000.0,
      'imageEmoji': '🥤',
    },
  ],
};

Map<String, Object?> foodMockRoutes() {
  final Map<String, Object?> routes = <String, Object?>{
    '/food/restaurants': _restaurants,
    '/food/orders': (Object? body) {
      final Map<String, dynamic> payload =
          (body as Map).cast<String, dynamic>();
      return <String, dynamic>{
        'id': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'confirmed',
        ...payload,
      };
    },
  };

  for (final Map<String, Object?> restaurant in _restaurants) {
    final String id = restaurant['id'] as String;
    routes['/food/restaurants/$id'] = restaurant;
    routes['/food/restaurants/$id/menu'] = _menu[id] ?? const [];
  }

  return routes;
}

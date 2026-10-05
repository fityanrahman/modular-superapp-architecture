const List<Map<String, Object?>> _destinations = [
  {
    'name': 'Sudirman Central Business District',
    'address': 'Jl. Jend. Sudirman, Jakarta',
    'estimatedFare': 25000.0,
  },
  {
    'name': 'Grand Indonesia',
    'address': 'Jl. M.H. Thamrin, Jakarta',
    'estimatedFare': 32000.0,
  },
  {
    'name': 'Soekarno-Hatta Airport',
    'address': 'Tangerang, Banten',
    'estimatedFare': 145000.0,
  },
  {
    'name': 'Kota Tua',
    'address': 'Jl. Taman Fatahillah, Jakarta',
    'estimatedFare': 48000.0,
  },
  {
    'name': 'Taman Mini Indonesia Indah',
    'address': 'Jl. Raya Taman Mini, Jakarta',
    'estimatedFare': 76000.0,
  },
];

Map<String, Object?> rideMockRoutes() => <String, Object?>{
      '/ride/destinations': _destinations,
    };

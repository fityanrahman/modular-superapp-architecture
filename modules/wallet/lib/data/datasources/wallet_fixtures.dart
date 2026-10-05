const double _balance = 250000.0;

const List<Map<String, Object?>> _transactions = [
  {
    'id': 'TRX-1001',
    'title': 'Top up',
    'amount': 100000.0,
    'date': '2024-05-01T09:15:00.000Z',
    'type': 'credit',
  },
  {
    'id': 'TRX-1002',
    'title': 'Nusantara Kitchen',
    'amount': -28000.0,
    'date': '2024-05-02T12:30:00.000Z',
    'type': 'debit',
  },
  {
    'id': 'TRX-1003',
    'title': 'Sakura Sushi',
    'amount': -45000.0,
    'date': '2024-05-03T18:05:00.000Z',
    'type': 'debit',
  },
  {
    'id': 'TRX-1004',
    'title': 'Order refund',
    'amount': 15000.0,
    'date': '2024-05-04T08:45:00.000Z',
    'type': 'credit',
  },
];

Map<String, Object?> walletMockRoutes() => <String, Object?>{
  '/wallet/balance': <String, Object?>{'balance': _balance, 'currency': 'IDR'},
  '/wallet/transactions': _transactions,
};

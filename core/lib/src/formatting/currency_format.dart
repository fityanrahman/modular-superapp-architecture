String formatRupiah(num value) {
  final String digits = value.round().abs().toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final int remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  final String sign = value < 0 ? '-' : '';
  return 'Rp $sign$buffer';
}

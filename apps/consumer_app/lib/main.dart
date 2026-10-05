import 'package:flutter/material.dart';

import 'app/composition_root.dart';
import 'app/consumer_app.dart';

void main() {
  runApp(ConsumerApp(compositionRoot: AppCompositionRoot()));
}

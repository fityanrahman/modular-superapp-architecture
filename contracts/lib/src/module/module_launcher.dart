import 'package:flutter/widgets.dart';

abstract interface class ModuleLauncher {
  String get moduleId;

  String get title;

  IconData get icon;

  Widget buildRoot(BuildContext context);
}

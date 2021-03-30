import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'views.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final orientations = <DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];
  SystemChrome.setPreferredOrientations(orientations);
  final overlays = <SystemUiOverlay>[];
  SystemChrome.setEnabledSystemUIOverlays(overlays);
  runApp(Paper());
}

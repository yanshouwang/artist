import 'package:artist/views/pac_man.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pac-Man',
      home: Scaffold(
        body: Center(
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: List.generate(
              6,
              (i) => PacMan(),
            ),
          ),
        ),
      ),
    );
  }
}

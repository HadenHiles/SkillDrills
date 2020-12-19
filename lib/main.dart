import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Nav.dart';

void main() {
  runApp(SkillDrills());
}

class SkillDrills extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Lock device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Skill Drills',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Color.fromRGBO(2, 164, 221, 1),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Nav(),
    );
  }
}

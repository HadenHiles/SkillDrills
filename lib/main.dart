import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skill_drills/theme/StateNotifier.dart';
import 'package:skill_drills/theme/Theme.dart';
import 'Login.dart';

// Setup a navigation key so that we can navigate without context
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider<ThemeStateNotifier>(
      create: (_) => ThemeStateNotifier(),
      child: SkillDrills(),
    ),
  );
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

    return Consumer<ThemeStateNotifier>(
      builder: (context, themeState, child) {
        return MaterialApp(
          title: 'Skill Drills',
          navigatorKey: navigatorKey,
          theme: SkillDrillsTheme.lightTheme,
          darkTheme: SkillDrillsTheme.darkTheme,
          themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.system,
          home: Login(),
        );
      },
    );
  }
}

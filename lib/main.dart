import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kzmusic_cross_platform/GetStarted.dart';
import 'package:kzmusic_cross_platform/SpotifyAuthCallback.dart';
import 'package:url_strategy/url_strategy.dart'; // 1. Import the package
import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/MainPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KzMusic',
      onGenerateRoute: (RouteSettings settings) {
        print("Router is handling path: ${settings.name}");

        // --- NEW, ROBUST ROUTING LOGIC ---
        // Parse the full route string into a Uri object.
        final Uri uri = Uri.parse(settings.name ?? '/');

        // Now, we can reliably get just the path part.
        final String routeName = uri.path;

        if (routeName == '/callback') {
          return MaterialPageRoute(
            builder: (context) => const AuthCallbackScreen(),
          );
        }

        // 2. ADD A ROUTE FOR YOUR MAIN PAGE
        if (routeName == '/main') {
          return MaterialPageRoute(
            builder: (context) => const MainPage(),
          );
        }

        // Default route is now the GetStartedScreen
        return MaterialPageRoute(
          builder: (context) => const GetStartedScreen(),
        );
      },
      initialRoute: '/',
    );
  }
}


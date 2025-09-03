import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kzmusic_cross_platform/GetStarted.dart';
import 'package:kzmusic_cross_platform/SpotifyAuthCallback.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        initialRoute: '/',
        routes: {
          '/': (context) => const GetStartedScreen(), // Your home page
          '/callback': (context) => const AuthCallbackScreen(), // Your redirect handler
        },
    );
  }
}


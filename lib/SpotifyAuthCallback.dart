// lib/auth_callback_screen.dart
// lib/auth_callback_screen.dart

import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/SpotifyAuthManager.dart';

class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _processRedirect();
  }

  void _processRedirect() async {
    // This now waits for the token exchange to complete.
    await SpotifyAuthManager().handleRedirect();

    // After the token is received (or fails), navigate to the main page.
    if (mounted) {
      // pushReplacementNamed prevents the user from pressing "back" and
      // ending up on the callback screen again, which would be confusing.
      Navigator.pushReplacementNamed(context, '/main'); // 3. NAVIGATE TO THE NEW MAIN PAGE
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
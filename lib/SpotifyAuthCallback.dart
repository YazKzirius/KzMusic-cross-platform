// lib/auth_callback_screen.dart

import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/SpotifyAuthManager.dart'; // Adjust path if needed

class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    // As soon as this screen loads, handle the redirect.
    _processRedirect();
  }

  void _processRedirect() async {
    await SpotifyAuthManager().handleRedirect();

    // After getting the token, navigate to the main screen.
    // pushReplacementNamed prevents the user from going "back" to the callback screen.
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while processing.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
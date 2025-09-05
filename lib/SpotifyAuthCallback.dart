// lib/auth_callback_screen.dart
// lib/auth_callback_screen.dart

import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/SpotifyAuthManager.dart';

/// IMPORTANT: This screen is ONLY used for the web build.
/// It acts as the redirect target after a user authenticates in their browser.
class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  // Create a single instance of the manager for this screen's lifecycle.
  final SpotifyAuthManager _authManager = SpotifyAuthManager();

  @override
  void initState() {
    super.initState();
    // Start the redirect process as soon as the screen is initialized.
    _processRedirect();
  }

  void _processRedirect() async {
    // For a web app, the full redirect URI is available in Uri.base.
    // We pass this to the handler to extract the authorization code and get a token.
    await _authManager.handleRedirect(Uri.base);

    // After the token exchange is attempted, check if we were successful.
    if (_authManager.accessToken != null) {
      // SUCCESS: If the widget is still mounted, navigate to the main app screen.
      if (mounted) {
        // pushReplacementNamed prevents the user from pressing the browser's "back"
        // button and ending up on this callback screen again.
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      // FAILURE: Navigate the user back to the login screen to try again.
      if (mounted) {
        // Assuming your GetStartedScreen is at the root route '/'.
        Navigator.pushReplacementNamed(context, '/');
        // You could also show an error message here.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This screen is transitional. The user should only see this for a brief moment.
    // A loading indicator is the perfect placeholder.
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A), // Match your app's theme
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38E07B)),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:kzmusic_cross_platform/SpotifyAuthManager.dart';
import 'package:logger/logger.dart'; // Import logger
import 'package:uni_links/uni_links.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final SpotifyAuthManager _authManager = SpotifyAuthManager();
  final Logger _logger = Logger();
  StreamSubscription? _sub;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // This check ensures the listener only runs on desktop platforms
    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      _initUniLinks();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Sets up the listener that will "catch" the Spotify redirect on desktop.
  /// THIS IS THE CODE THAT IS CURRENTLY FAILING TO START BECAUSE OF THE NATIVE CRASH.
  Future<void> _initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (uri != null && mounted) {
        _logger.i("✅ Desktop redirect received by app: $uri");
        setState(() {
          _isLoading = true;
        });

        await _authManager.handleRedirect(uri);

        // After the token is received, this logic will finally execute.
        if (_authManager.accessToken != null) {
          _logger.i("✅ Auth creds received on desktop! Navigating to main page...");
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        } else {
          _logger.e("⛔️ Failed to get auth creds after desktop redirect.");
          if (mounted) {
            setState(() { _isLoading = false; });
          }
        }
      }
    }, onError: (err) {
      _logger.e("⛔️ uni_links listener error: $err");
      if (mounted) { setState(() { _isLoading = false; }); }
    });
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    // This launches the browser. The app then waits for the _initUniLinks listener to fire.
    await _authManager.login();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              // You can use MainAxisAlignment.center to center the entire column
              // or use Spacers/SizedBoxes for more specific control.
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 64.0),
                // App Logo
                Image.asset(
                  'assets/logo.png', // Make sure this path is correct
                  width: 180.0,
                  height: 180.0,
                ),
                const SizedBox(height: 48.0),
                // Get Started Button
                SizedBox(
                  width: double.infinity, // Makes the button stretch
                  height: 56.0,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6200EE), // Equivalent to @color/purple
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28.0),
                // Loading Spinner / ProgressBar
                if (_isLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
                else
                // Use a SizedBox to take up no space when not loading
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
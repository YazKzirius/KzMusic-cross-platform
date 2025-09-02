import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  // State variable to control the visibility of the loading spinner.
  bool _isLoading = false;

  void _handleGetStarted() {
    // When the button is pressed, show the loading spinner.
    setState(() {
      _isLoading = true;
    });

    // In a real app, you would perform an action here, like navigating
    // to a new screen or fetching data. For this example, we'll just
    // pretend to load for 2 seconds.
    Future.delayed(const Duration(seconds: 2), () {
      // After the task is done, hide the spinner.
      if (mounted) { // Check if the widget is still in the tree.
        setState(() {
          _isLoading = false;
        });
      }
    });
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
                    onPressed: _isLoading ? null : _handleGetStarted,
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
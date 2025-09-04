// lib/SpotifyAuthManager.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb; // To check if we are on the web
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher.dart'; // You need this package

class SpotifyAuthManager {

  // --- START OF CONFIGURATION CHECKLIST ---

  // CHECK 1: Is this your exact Client ID from the dashboard?
  String clientId = '21dc131ad4524c6aae75a9d0256b1b70';

  // CHECK 2: Is this your exact Client Secret? (For production, this must be on a server)
  String clientSecret = "7c15410b4f714a839cc3ad8f661a6513";

  // CHECK 3: This is the most important value. It MUST be an EXACT match.
  // No trailing slash. It must include "/callback".
  String webRedirectUri = 'http://localhost:8888/callback';

  // --- END OF CONFIGURATION CHECKLIST ---

  String mobileRedirectUri = 'kzmusic://callback';
  final Logger _logger = Logger(printer: PrettyPrinter());

  Future<void> login() async {
    if (kIsWeb) {
      // The scopes you are requesting. Make sure they are space-separated.
      final scope = 'user-read-private user-read-email user-modify-playback-state';

      // The authorization URL is built from the values above.
      final Uri authUri = Uri.parse(
          'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$webRedirectUri&scope=$scope'
      );

      if (await canLaunchUrl(authUri)) {
        await launchUrl(authUri, webOnlyWindowName: '_self');
      } else {
        throw 'Could not launch $authUri';
      }
    } else {
      // MOBILE FLOW (unchanged)
      try {
        var authenticationToken = await SpotifySdk.getAccessToken(
            clientId: clientId,
            redirectUrl: mobileRedirectUri,
            scope: 'app-remote-control,user-modify-playback-state,playlist-read-private,user-read-currently-playing');
        setStatus('✅ Mobile token received: $authenticationToken');
      } on PlatformException catch (e) {
        setStatus('⛔️ Platform Error: ${e.code}', message: e.message);
      } on MissingPluginException {
        setStatus('⛔️ Missing Plugin Exception');
      }
    }
  }

  // This function is ONLY for the web callback.
  Future<void> handleRedirect() async {
    final Uri uri = Uri.base;
    if (uri.queryParameters.containsKey('code')) {
      final String code = uri.queryParameters['code']!;
      _logger.i('✅ Success! Authorization Code received: $code');
      await _exchangeCodeForToken(code);
    } else if (uri.queryParameters.containsKey('error')) {
      final String error = uri.queryParameters['error']!;
      _logger.e('⛔️ Error! Spotify returned an error: $error');
    }
  }

  // In the _exchangeCodeForToken method...
  Future<void> _exchangeCodeForToken(String code) async {
    final Uri tokenUrl = Uri.parse('https://accounts.spotify.com/api/token');
    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

    final response = await http.post(
      tokenUrl,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': basicAuth,
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': webRedirectUri, // This must also match EXACTLY
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final String accessToken = body['access_token'];
      _logger.i('🎉🎉🎉 Access Token Received! 🎉🎉🎉\n$accessToken');
    } else {
      _logger.e('🚨🚨🚨 FAILED TO GET ACCESS TOKEN 🚨🚨🚨');
      _logger.e('Status Code: ${response.statusCode}');
      _logger.e('Response Body: ${response.body}');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}

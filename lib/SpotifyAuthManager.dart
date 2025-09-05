// lib/SpotifyAuthManager.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyAuthManager {
  // --- CONFIGURATION ---
  final String clientId = '21dc131ad4524c6aae75a9d0256b1b70';
  final String clientSecret = "7c15410b4f714a839cc3ad8f661a6513";

  final String desktopWebRedirectUri = 'http://localhost:8888/callback';
  final String mobileRedirectUri = 'kzmusic://callback';
  // --- END OF CONFIGURATION ---

  final Logger _logger = Logger(printer: PrettyPrinter());
  String? accessToken;

  Future<bool> login() async {
    final bool isDesktop = !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
    final bool useMobileSDK = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    if (useMobileSDK) {
      try {
        var token = await SpotifySdk.getAccessToken(
            clientId: clientId,
            redirectUrl: mobileRedirectUri,
            scope: 'app-remote-control,user-modify-playback-state,playlist-read-private,user-read-currently-playing');
        setStatus('✅ Mobile token received');
        accessToken = token;
        return true;
      } on PlatformException catch (e) {
        setStatus('⛔️ Platform Error: ${e.code}', message: e.message);
        return false;
      } on MissingPluginException {
        setStatus('⛔️ Missing Plugin Exception. Are you on a mobile device?');
        return false;
      }
    } else if (kIsWeb || isDesktop) {
      final scope = 'user-read-private user-read-email user-modify-playback-state';
      final Uri authUri = Uri.parse(
          'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$desktopWebRedirectUri&scope=$scope');

      try {
        if (await canLaunchUrl(authUri)) {
          await launchUrl(authUri, webOnlyWindowName: '_self');
          return true;
        } else {
          throw 'Could not launch $authUri';
        }
      } catch (e) {
        _logger.e("Could not launch URL: $e");
        return false;
      }
    } else {
      _logger.e("Unsupported platform for login.");
      return false;
    }
  }

  Future<void> handleRedirect(Uri uri) async {
    if (uri.queryParameters.containsKey('code')) {
      final String code = uri.queryParameters['code']!;
      _logger.i('✅ Success! Authorization Code received.');
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

    try {
      //
      // ========= THE FIX IS HERE =========
      //
      final response = await http.post(
        tokenUrl,
        headers: {
          // DO NOT set the 'Content-Type' header here.
          // The http package does it automatically when the body is a Map.
          'Authorization': basicAuth,
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': desktopWebRedirectUri, // This must also match EXACTLY
        },
        // It's good practice to specify the encoding.
        encoding: Encoding.getByName('utf-8'),
      );
      //
      // ===================================
      //

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        // Save the access token to our class property.
        accessToken = body['access_token'];
        _logger.i('🎉🎉🎉 Access Token Received! 🎉🎉🎉\n$accessToken');
      } else {
        _logger.e('🚨🚨🚨 FAILED TO GET ACCESS TOKEN 🚨🚨🚨');
        _logger.e('Status Code: ${response.statusCode}');
        _logger.e('Response Body: ${response.body}');
      }
    } catch (e) {
      _logger.e("⛔ Error exchanging code for token: $e");
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}

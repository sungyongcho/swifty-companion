import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OAuthService {
  // Private constructor
  OAuthService._internal();

  // Singleton instance
  static final OAuthService _instance = OAuthService._internal();

  // Factory constructor to return the same instance
  factory OAuthService() {
    return _instance;
  }

  final FlutterAppAuth _appAuth = FlutterAppAuth();

  /// Save the token to persistent storage
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  /// Retrieve the token from persistent storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// Clear the token from persistent storage
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  /// Perform OAuth login and return the access token
  Future<String?> performOAuthLogin() async {
    final String clientId = dotenv.env['CLIENT_ID']!;
    final String clientSecret = dotenv.env['CLIENT_SECRET']!;
    final String redirectUri = dotenv.env['REDIRECT_URI']!;
    const String authorizationEndpoint =
        'https://api.intra.42.fr/oauth/authorize';
    const String tokenEndpoint = 'https://api.intra.42.fr/oauth/token';

    const AuthorizationServiceConfiguration serviceConfig =
        AuthorizationServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint);

    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          clientSecret: clientSecret,
          serviceConfiguration: serviceConfig,
          scopes: ['public'], // Add required scopes
        ),
      );

      if (result != null) {
        // Save the token for future use
        await saveToken(result.accessToken!);
        return result.accessToken; // Return the access token
      }
    } catch (e) {
      // Improved error logging
      print('OAuth Login Failed: $e');
      throw Exception('OAuth Login Failed: $e');
    }
    return null; // Return null if login fails
  }

  /// Fetch user details using the access token
  Future<Map<String, dynamic>> fetchUserDetails(String accessToken) async {
    const String userInfoEndpoint = 'https://api.intra.42.fr/v2/me';

    try {
      final response = await http.get(
        Uri.parse(userInfoEndpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse and return user details
      } else if (response.statusCode == 401) {
        // Token might be invalid or expired
        throw Exception('Unauthorized: Token may have expired.');
      } else {
        throw Exception('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      throw Exception('Error fetching user details: $e');
    }
  }
}

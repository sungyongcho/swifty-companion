import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OAuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

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
          scopes: ['public'],
        ),
      );

      if (result != null) {
        return result.accessToken; // Return the access token
      }
    } catch (e) {
      throw Exception('OAuth Login Failed: $e');
    }
    return null; // Return null if login fails
  }

  Future<Map<String, dynamic>> fetchUserDetails(String accessToken) async {
    const String userInfoEndpoint = 'https://api.intra.42.fr/v2/me';

    final response = await http.get(
      Uri.parse(userInfoEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}

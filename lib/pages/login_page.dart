import 'package:flutter/material.dart';
import 'package:swifty_companion/services/oauth_service.dart';

class LoginPage extends StatelessWidget {
  final OAuthService _authService = OAuthService(); // Instance of OAuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('swifty-companion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Perform OAuth login
                  final token = await _authService.performOAuthLogin();

                  if (token != null) {
                    // Fetch user details using the access token
                    final userDetails =
                        await _authService.fetchUserDetails(token);

                    // Navigate to the profile page with user details
                    Navigator.pushReplacementNamed(
                      context,
                      '/profile',
                      arguments: {
                        'username': userDetails['username'],
                        'first_name': userDetails['first_name'],
                        'last_name': userDetails['last_name'],
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed')),
                    );
                  }
                } catch (e) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

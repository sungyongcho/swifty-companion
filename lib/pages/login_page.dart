import 'package:flutter/material.dart';
import 'package:swifty_companion/services/oauth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final OAuthService authService;

  LoginPage({required this.authService});

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
                  // Perform OAuth login and get the token
                  final token = await authService.performOAuthLogin();

                  if (token != null) {
                    // Save the token
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('accessToken', token);

                    // Fetch user details and save them
                    final userDetails =
                        await authService.fetchUserDetails(token);
                    await prefs.setString(
                        'userDetails', jsonEncode(userDetails));
                    final userSkills = await authService.fetchUserSkills(
                        token, userDetails['id']);
                    await prefs.setString('userSkills', jsonEncode(userSkills));

                    // Navigate to profile page
                    Navigator.pushReplacementNamed(
                      context,
                      '/profile',
                      arguments: userDetails,
                    );
                  } else {
                    // Show login failed message
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

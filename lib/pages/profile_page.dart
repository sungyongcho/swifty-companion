import 'package:flutter/material.dart';
import 'package:swifty_companion/services/oauth_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final OAuthService authService;

  ProfilePage({required this.authService});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userDetailsString = prefs.getString('userDetails');
    if (userDetailsString != null) {
      setState(() {
        userDetails = jsonDecode(userDetailsString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userDetails == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('User details are missing. Please log in again.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userDetails!['image']?['link']),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),
            Text(
              'Username: ${userDetails!['login']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'First Name: ${userDetails!['first_name']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Last Name: ${userDetails!['last_name']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data

    widget.authService.clearToken(); // Clear token from the auth service

    Navigator.pushReplacementNamed(context, '/');
  }
}

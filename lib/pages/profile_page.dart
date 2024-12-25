import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: ${args['username']}'),
            Text('First Name: ${args['first_name']}'),
            Text('Last Name: ${args['last_name']}'),
            const SizedBox(height: 20), // Add spacing
            ElevatedButton(
              onPressed: () {
                // Handle logout logic here
                _logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Perform logout actions here, such as clearing tokens or resetting state

    // Navigate back to the login page
    Navigator.pushReplacementNamed(context, '/');
  }
}

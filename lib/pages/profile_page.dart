import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display profile image
            CircleAvatar(
              radius: 50, // Adjust size as needed
              backgroundImage: NetworkImage(userDetails['image']?['link']),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 20), // Add spacing
            // Display user details
            Text(
              'Username: ${userDetails['login']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'First Name: ${userDetails['first_name']}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Last Name: ${userDetails['last_name']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20), // Add spacing
            // Logout button
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

  void _logout(BuildContext context) {
    // Perform logout actions here, such as clearing tokens or resetting state

    // Navigate back to the login page
    Navigator.pushReplacementNamed(context, '/');
  }
}

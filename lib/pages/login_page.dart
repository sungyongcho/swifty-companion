import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
                // final userDetails = await AuthService.login();
                // if (userDetails != null) {
                //   // Navigate to the Profile Page
                //   Navigator.pushReplacementNamed(
                //     context,
                //     '/main',
                //     arguments: {
                //       'username': userDetails['username'],
                //       'first_name': userDetails['first_name'],
                //       'last_name': userDetails['last_name'],
                //     },
                //   );
                // }
                Navigator.pushReplacementNamed(context, '/profile');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

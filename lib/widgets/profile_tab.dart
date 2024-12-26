import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> userDetails;

  ProfileTab({required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(userDetails['image']?['link']),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 20),
          Text(
            'Login: ${userDetails['login']}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Name: ${userDetails['usual_full_name']}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Wallet: ${userDetails['wallet']}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Evaluation Points: ${userDetails['correction_point']}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Email: ${userDetails['email']}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

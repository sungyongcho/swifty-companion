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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

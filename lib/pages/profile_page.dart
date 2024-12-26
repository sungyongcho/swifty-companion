import 'package:flutter/material.dart';
import 'package:swifty_companion/services/oauth_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/widgets/profile_tab.dart';
import 'package:swifty_companion/widgets/projects_tab.dart';
import 'package:swifty_companion/widgets/skills_tab.dart';

class ProfilePage extends StatefulWidget {
  final OAuthService authService;

  ProfilePage({required this.authService});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userDetails;
  int _currentIndex = 0;

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

    final List<Widget> _pages = [
      ProfileTab(userDetails: userDetails!), // First tab: Profile content
      SkillsTab(), // Second tab: Skills placeholder
      ProjectsTab(
        userId: userDetails?['id'] ?? 0, // Fix: Safely handle `id` extraction
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.logout), // Logout icon
          onPressed: () {
            // Show a confirmation dialog before logging out
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), // Cancel action
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      _logout(context); // Call logout
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile icon
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), // Skills icon
            label: 'Skills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder), // Projects icon
            label: 'Projects',
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data

    widget.authService.clearToken(); // Clear token from the auth service

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifty_companion/services/oauth_service.dart';

class ProjectsTab extends StatefulWidget {
  final int userId;

  ProjectsTab({required this.userId});

  @override
  _ProjectsTabState createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  final OAuthService _oauthService = OAuthService();
  List<dynamic> projects = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchProjects();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProjects() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        throw Exception('Access token not found. Please log in again.');
      }

      final newProjects = await _oauthService.fetchUserProjects(
        accessToken,
        widget.userId,
        currentPage,
      );

      setState(() {
        projects.addAll(newProjects);
        currentPage++;
        if (newProjects.isEmpty || newProjects.length < 30) {
          hasMore = false; // No more data to fetch
        }
      });
    } catch (e) {
      print('Error fetching projects: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: projects.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == projects.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final project = projects[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['project']['name'] ?? 'Unknown Project',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Status: ${project['status'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Final Mark: ${project['final_mark']?.toString() ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Validated: ${project['validated?'] == true ? "Yes" : "No"}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

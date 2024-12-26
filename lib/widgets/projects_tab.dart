import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsTab extends StatefulWidget {
  @override
  _ProjectsTabState createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  List<dynamic>? projects;

  @override
  void initState() {
    super.initState();
    _loadUserProjects();
  }

  Future<void> _loadUserProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsString = prefs.getString('userProjects');
    if (projectsString != null) {
      setState(() {
        projects = jsonDecode(projectsString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (projects == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: projects!.length,
      itemBuilder: (context, index) {
        final project = projects![index];

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

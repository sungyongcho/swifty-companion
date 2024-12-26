import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SkillsTab extends StatefulWidget {
  @override
  _SkillsTabState createState() => _SkillsTabState();
}

class _SkillsTabState extends State<SkillsTab> {
  List<dynamic>? skills;

  @override
  void initState() {
    super.initState();
    _loadUserSkills();
  }

  Future<void> _loadUserSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final skillsString = prefs.getString('userSkills');
    if (skillsString != null) {
      setState(() {
        skills = jsonDecode(skillsString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (skills == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: skills!.length,
      itemBuilder: (context, index) {
        final skill = skills![index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill['name'] ?? 'Unknown Skill',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Level: ${skill['level']?.toStringAsFixed(2) ?? 'Unknown'}',
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

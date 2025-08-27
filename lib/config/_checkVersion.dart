import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubVersionCheck extends StatefulWidget {
  const GithubVersionCheck({super.key});

  @override
  State<GithubVersionCheck> createState() => _GithubVersionCheckState();
}

class _GithubVersionCheckState extends State<GithubVersionCheck> {
  @override
  void initState() {
    super.initState();
    _checkGithubVersion();
  }

  Future<void> _checkGithubVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    // Replace with your GitHub repo
    final githubApiUrl =
        'https://api.github.com/repos/yourusername/yourrepo/releases/latest';

    final response = await http.get(Uri.parse(githubApiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final latestVersion = data['tag_name'] as String; // e.g., "v1.2.0"
      final releaseUrl = data['html_url'] as String;

      if (_isNewerVersion(latestVersion, currentVersion)) {
        _showUpdateDialog(latestVersion, releaseUrl);
      }
    }
  }

  bool _isNewerVersion(String latest, String current) {
    // Remove "v" prefix if present
    latest = latest.replaceFirst('v', '');
    final latestParts = latest.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true;
      } else if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }

  void _showUpdateDialog(String latestVersion, String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text(
          'A new version ($latestVersion) is available. Please update to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(updateUrl))) {
                await launchUrl(
                  Uri.parse(updateUrl),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch update URL')),
                );
              }
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(); // Or your main widget tree
  }
}

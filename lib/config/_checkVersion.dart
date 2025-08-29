import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const String repoOwner = "yared098";
  static const String repoName = "yeneBingoMobile";

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      debugPrint("🌐 Checking GitHub releases...");

      final response = await http.get(
        Uri.parse(
          "https://api.github.com/repos/yared098/yeneBingoMobile/releases/latest",
        ),
      );

      debugPrint("🌐 GitHub API response: ${response.statusCode}");

      if (response.statusCode != 200) return;

      final json = jsonDecode(response.body);
      final latestVersion = json['tag_name'];
      final assets = json['assets'] as List;

      debugPrint("✅ Latest GitHub version: $latestVersion");
      debugPrint("📦 Found ${assets.length} assets in release");

      String? apkUrl;
      for (var asset in assets) {
        if (asset['name'].endsWith('.apk')) {
          apkUrl = asset['browser_download_url'];
          break;
        }
      }

      if (apkUrl == null) {
        debugPrint("⚠️ No .apk asset found in release");
        apkUrl = json['html_url']; // fallback → release page
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = "v${packageInfo.version}";

      debugPrint(
        "🔍 Comparing versions → latest: $latestVersion vs current: $currentVersion",
      );
      if (_isNewerVersion(latestVersion, currentVersion)) {
        debugPrint("🚨 Update required → showing update dialog");
        _showUpdateDialog(context, latestVersion, apkUrl!);
      } else {
        debugPrint("✅ App is up to date");
      }
    } catch (e) {
      debugPrint("❌ Error checking update: $e");
    }
  }

  /// Compares semantic versions, ignoring build metadata (+6)
  static bool _isNewerVersion(String latest, String current) {
    // Remove leading 'v'
    latest = latest.replaceAll('v', '');
    current = current.replaceAll('v', '');

    // Split into semantic version and build number
    List<String> latestSplit = latest.split('+');
    List<String> currentSplit = current.split('+');

    List<int> latestParts = latestSplit[0].split('.').map(int.parse).toList();
    List<int> currentParts = currentSplit[0].split('.').map(int.parse).toList();

    int latestBuild = latestSplit.length > 1 ? int.parse(latestSplit[1]) : 0;
    int currentBuild = currentSplit.length > 1 ? int.parse(currentSplit[1]) : 0;

    // Compare semantic version parts
    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }

    // Semantic versions are equal, compare build numbers
    if (latestBuild > currentBuild) return true;
    return false;
  }

  static void _showUpdateDialog(
    BuildContext context,
    String latestVersion,
    String apkUrl,
  ) {
    bool isDirectApk = apkUrl.endsWith(".apk");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Update Available 🚀"),
        content: Text(
          "A new version ($latestVersion) is available. Please update.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (isDirectApk) {
                await _downloadAndInstallApk(apkUrl);
              } else {
                await _launchURL(apkUrl); // open release page if no APK
              }
            },
            child: Text(isDirectApk ? "Download & Install" : "Go to Release"),
          ),
        ],
      ),
    );
  }

  static Future<void> _downloadAndInstallApk(String apkUrl) async {
    try {
      debugPrint("⬇️ Downloading APK: $apkUrl");
      final response = await http.get(Uri.parse(apkUrl));
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/update.apk");
      await file.writeAsBytes(response.bodyBytes);

      debugPrint("✅ APK downloaded: ${file.path}");

      // Open installer
      await Process.run("pm", ["install", "-r", file.path]);
    } catch (e) {
      debugPrint("❌ Error installing APK: $e");
    }
  }

  static Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ Could not launch $url");
    }
  }
}
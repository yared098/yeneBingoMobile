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
          "https://api.github.com/repos/$repoOwner/$repoName/releases/latest",
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
      final currentVersion =
          "v${packageInfo.version}+${packageInfo.buildNumber}";

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

  /// Compare semantic version + build
  static bool _isNewerVersion(String latest, String current) {
    latest = latest.replaceAll('v', '');
    current = current.replaceAll('v', '');

    List<String> latestSplit = latest.split('+');
    List<String> currentSplit = current.split('+');

    List<int> latestParts = latestSplit[0]
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    List<int> currentParts = currentSplit[0]
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    int latestBuild = latestSplit.length > 1
        ? int.tryParse(latestSplit[1]) ?? 0
        : 0;
    int currentBuild = currentSplit.length > 1
        ? int.tryParse(currentSplit[1]) ?? 0
        : 0;

    int maxLen = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;
    for (int i = 0; i < maxLen; i++) {
      int l = (i < latestParts.length) ? latestParts[i] : 0;
      int c = (i < currentParts.length) ? currentParts[i] : 0;

      if (l > c) return true;
      if (l < c) return false;
    }

    return latestBuild > currentBuild;
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
                await _downloadAndInstallApk(context, apkUrl);
              } else {
                await _launchURL(apkUrl);
              }
            },
            child: Text(isDirectApk ? "Download & Install" : "Go to Release"),
          ),
        ],
      ),
    );
  }

  /// Download with progress
  static Future<void> _downloadAndInstallApk(
    BuildContext context,
    String apkUrl,
  ) async {
    try {
      debugPrint("⬇️ Downloading APK: $apkUrl");

      final request = await HttpClient().getUrl(Uri.parse(apkUrl));
      final response = await request.close();

      final contentLength = response.contentLength;
      int bytesReceived = 0;

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/update.apk");
      final raf = file.openSync(mode: FileMode.write);

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              double progress =
                  bytesReceived / (contentLength == -1 ? 1 : contentLength);

              return AlertDialog(
                title: const Text("Downloading Update..."),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 10),
                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
              );
            },
          );
        },
      );

      // Listen for chunks
      await for (var data in response) {
        raf.writeFromSync(data);
        bytesReceived += data.length;

        // Update UI
        if (context.mounted) {
          Navigator.of(context).pop(); // close old
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              double progress =
                  bytesReceived / (contentLength == -1 ? 1 : contentLength);
              return AlertDialog(
                title: const Text("Downloading Update..."),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 10),
                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
              );
            },
          );
        }
      }

      await raf.close();

      // Close progress dialog
      if (context.mounted) Navigator.of(context).pop();

      debugPrint("✅ APK downloaded: ${file.path}");

      // Open installer (NOTE: pm install won't work without root; use Intent instead in production)
      await Process.run("pm", ["install", "-r", file.path]);
    } catch (e) {
      debugPrint("❌ Error installing APK: $e");
    }
  }

  static Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ Could not launch $url");
    }
  }
}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offlinebingo/ZeroApp/splash_page.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// HTTP override (dev only)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        debugPrint('⚠️ Bypassing SSL for $host:$port');
        return true;
      };
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BingoAppWrapper());
}

class BingoAppWrapper extends StatelessWidget {
  const BingoAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<int>(create: (_) => 0)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bingo App',
        theme: ThemeData(primarySwatch: Colors.red),
        home: const VersionCheckWrapper(),
      ),
    );
  }
}

/// Wrapper that checks GitHub version before showing SplashScreen
class VersionCheckWrapper extends StatefulWidget {
  const VersionCheckWrapper({super.key});

  @override
  State<VersionCheckWrapper> createState() => _VersionCheckWrapperState();
}

class _VersionCheckWrapperState extends State<VersionCheckWrapper> {
  @override
  void initState() {
    super.initState();
    _checkGithubVersion();
  }

  Future<void> _checkGithubVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    // GitHub latest release API
    const githubApiUrl =
        'https://api.github.com/repos/yared098/yeneBingoMobile/releases/latest';

    try {
      final response = await http.get(Uri.parse(githubApiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['tag_name'] as String; // e.g., "v1.2.0"

        // Look for APK asset in release
        String? apkUrl;
        if (data['assets'] != null) {
          final assets = data['assets'] as List<dynamic>;
          final apkAsset = assets.firstWhere(
            (a) => (a['name'] as String).endsWith('.apk'),
            orElse: () => {},
          );
          if (apkAsset is Map<String, dynamic>) {
            apkUrl = apkAsset['browser_download_url'] as String?;
          }
        }

        // fallback: release page
        final releaseUrl =
            apkUrl ?? data['html_url'] as String; // GitHub release URL

        if (_isNewerVersion(latestVersion, currentVersion)) {
          _showUpdateDialog(latestVersion, releaseUrl);
          return; // Block until user updates
        }
      }
    } catch (e) {
      debugPrint("⚠️ GitHub version check failed: $e");
    }

    // No update required → go to splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  bool _isNewerVersion(String latest, String current) {
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

 void _showUpdateDialog(String latestVersion, String apkUrl) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Update Available'),
      content: Text(
        'A new version ($latestVersion) is available. Download and install now?',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _downloadAndInstallApk(apkUrl);
          },
          child: const Text('Download & Install'),
        ),
      ],
    ),
  );
}

Future<void> _downloadAndInstallApk(String apkUrl) async {
  try {
    final dir = await getTemporaryDirectory();
    final filePath = "${dir.path}/update.apk";

    // Download APK
    final dio = Dio();
    await dio.download(
      apkUrl,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );

    // Open APK (this will trigger installer)
    await OpenFilex.open(filePath);
  } catch (e) {
    debugPrint("❌ Failed to download or install APK: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

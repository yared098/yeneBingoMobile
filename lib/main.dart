// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:offlinebingo/ZeroApp/splash_page.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// /// HTTP override (dev only)
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) {
//         debugPrint('⚠️ Bypassing SSL for $host:$port');
//         return true;
//       };
//   }
// }

// Future<void> main() async {
//   HttpOverrides.global = MyHttpOverrides();
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   runApp(const BingoAppWrapper());
// }

// class BingoAppWrapper extends StatelessWidget {
//   const BingoAppWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [Provider<int>(create: (_) => 0)],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Bingo App',
//         theme: ThemeData(primarySwatch: Colors.red),
//         home: const VersionCheckWrapper(),
//       ),
//     );
//   }
// }

// /// Wrapper that checks GitHub version before showing SplashScreen
// class VersionCheckWrapper extends StatefulWidget {
//   const VersionCheckWrapper({super.key});

//   @override
//   State<VersionCheckWrapper> createState() => _VersionCheckWrapperState();
// }

// class _VersionCheckWrapperState extends State<VersionCheckWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     _checkGithubVersion();
//   }

//   // Future<void> _checkGithubVersion() async {
//   //   final packageInfo = await PackageInfo.fromPlatform();
//   //   final currentVersion = packageInfo.version;

//   //   // GitHub latest release API
//   //   const githubApiUrl =
//   //       'https://api.github.com/repos/yared098/yeneBingoMobile/releases/latest';

//   //   try {
//   //     final response = await http.get(Uri.parse(githubApiUrl));

//   //     if (response.statusCode == 200) {
//   //       final data = jsonDecode(response.body);
//   //       final latestVersion = data['tag_name'] as String; // e.g., "v1.2.0"

//   //       // Look for APK asset in release
//   //       String? apkUrl;
//   //       if (data['assets'] != null) {
//   //         final assets = data['assets'] as List<dynamic>;
//   //         final apkAsset = assets.firstWhere(
//   //           (a) => (a['name'] as String).endsWith('.apk'),
//   //           orElse: () => {},
//   //         );
//   //         if (apkAsset is Map<String, dynamic>) {
//   //           apkUrl = apkAsset['browser_download_url'] as String?;
//   //         }
//   //       }

//   //       // fallback: release page
//   //       final releaseUrl =
//   //           apkUrl ?? data['html_url'] as String; // GitHub release URL

//   //       if (_isNewerVersion(latestVersion, currentVersion)) {
//   //         _showUpdateDialog(latestVersion, releaseUrl);
//   //         return; // Block until user updates
//   //       }
//   //     }
//   //   } catch (e) {
//   //     debugPrint("⚠️ GitHub version check failed: $e");
//   //   }

//   //   // No update required → go to splash screen
//   //   Navigator.pushReplacement(
//   //     context,
//   //     MaterialPageRoute(builder: (_) => const SplashScreen()),
//   //   );
//   // }

//   // bool _isNewerVersion(String latest, String current) {
//   //   latest = latest.replaceFirst('v', '');
//   //   final latestParts = latest.split('.').map(int.parse).toList();
//   //   final currentParts = current.split('.').map(int.parse).toList();

//   //   for (int i = 0; i < latestParts.length; i++) {
//   //     if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
//   //       return true;
//   //     } else if (latestParts[i] < currentParts[i]) {
//   //       return false;
//   //     }
//   //   }
//   //   return false;
//   // }

//   void _showUpdateDialog(String latestVersion, String apkUrl) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Update Available'),
//         content: Text(
//           'A new version ($latestVersion) is available. Download and install now?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // ✅ close update dialog first
//               _downloadAndInstallApk(apkUrl); // then start download
//             },
//             child: const Text('Download & Install'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Future<void> _downloadAndInstallApk(String apkUrl) async {
//   //   final dir = await getTemporaryDirectory();
//   //   final filePath = "${dir.path}/update.apk";
//   //   final dio = Dio();

//   //   double progress = 0;
//   //   late StateSetter dialogSetState;

//   //   // Show progress dialog
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (context) {
//   //       return StatefulBuilder(
//   //         builder: (context, setState) {
//   //           dialogSetState = setState;
//   //           return AlertDialog(
//   //             title: const Text("Downloading Update"),
//   //             content: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 LinearProgressIndicator(value: progress),
//   //                 const SizedBox(height: 10),
//   //                 Text("${(progress * 100).toStringAsFixed(0)}%"),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );

//   //   try {
//   //     await dio.download(
//   //       apkUrl,
//   //       filePath,
//   //       onReceiveProgress: (received, total) {
//   //         if (total != -1) {
//   //           dialogSetState(() {
//   //             progress = received / total;
//   //           });
//   //         }
//   //       },
//   //     );

//   //     Navigator.of(context).pop(); // ✅ close progress dialog
//   //     await OpenFilex.open(filePath); // install
//   //   } catch (e) {
//   //     Navigator.of(context).pop(); // ✅ close progress dialog on error
//   //     debugPrint("❌ Failed to download or install APK: $e");
//   //   }
//   // }
//   Future<void> _checkGithubVersion() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     final currentVersion = packageInfo.version;
//     debugPrint("📦 Current app version: $currentVersion");

//     // GitHub latest release API
//     const githubApiUrl =
//         'https://api.github.com/repos/yared098/yeneBingoMobile/releases/latest';
//     debugPrint("🌐 Checking GitHub release: $githubApiUrl");

//     try {
//       final response = await http.get(Uri.parse(githubApiUrl));
//       debugPrint("🌐 GitHub API response: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final latestVersion = data['tag_name'] as String; // e.g., "v1.2.0"
//         debugPrint("✅ Latest GitHub version: $latestVersion");

//         // Look for APK asset in release
//         String? apkUrl;
//         if (data['assets'] != null) {
//           final assets = data['assets'] as List<dynamic>;
//           debugPrint("📦 Found ${assets.length} assets in release");
//           final apkAsset = assets.firstWhere(
//             (a) => (a['name'] as String).endsWith('.apk'),
//             orElse: () {
//               debugPrint("⚠️ No .apk asset found in release");
//               return {};
//             },
//           );
//           if (apkAsset is Map<String, dynamic>) {
//             apkUrl = apkAsset['browser_download_url'] as String?;
//             debugPrint("📥 APK download URL: $apkUrl");
//           }
//         }

//         // fallback: release page
//         final releaseUrl =
//             apkUrl ?? data['html_url'] as String; // GitHub release URL
//         debugPrint("🔗 Release URL: $releaseUrl");

//         if (_isNewerVersion(latestVersion, currentVersion)) {
//           debugPrint("🚨 Update required → showing update dialog");
//           _showUpdateDialog(latestVersion, releaseUrl);
//           return; // Block until user updates
//         } else {
//           debugPrint("👌 App is up to date, continuing");
//         }
//       }
//     } catch (e) {
//       debugPrint("⚠️ GitHub version check failed: $e");
//     }

//     // No update required → go to splash screen
//     debugPrint("➡️ Navigating to SplashScreen");
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const SplashScreen()),
//     );
//   }

//   bool _isNewerVersion(String latest, String current) {
//     debugPrint("🔍 Comparing versions → latest: $latest vs current: $current");

//     latest = latest.replaceFirst('v', '');
//     final latestParts = latest.split('.').map(int.parse).toList();
//     final currentParts = current.split('.').map(int.parse).toList();

//     for (int i = 0; i < latestParts.length; i++) {
//       if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
//         debugPrint("✅ Newer version detected at part $i");
//         return true;
//       } else if (latestParts[i] < currentParts[i]) {
//         debugPrint("❌ Current version is newer at part $i");
//         return false;
//       }
//     }
//     return false;
//   }

//   Future<void> _downloadAndInstallApk(String apkUrl) async {
//     debugPrint("📥 Starting APK download: $apkUrl");
//     final dir = await getTemporaryDirectory();
//     final filePath = "${dir.path}/update.apk";
//     final dio = Dio();

//     debugPrint("📂 Download path: $filePath");

//     double progress = 0;
//     late StateSetter dialogSetState;

//     // Show progress dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             dialogSetState = setState;
//             return AlertDialog(
//               title: const Text("Downloading Update"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   LinearProgressIndicator(value: progress),
//                   const SizedBox(height: 10),
//                   Text("${(progress * 100).toStringAsFixed(0)}%"),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );

//     try {
//       await dio.download(
//         apkUrl,
//         filePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             final percent = (received / total) * 100;
//             debugPrint("⬇️ Download progress: ${percent.toStringAsFixed(0)}%");
//             dialogSetState(() {
//               progress = received / total;
//             });
//           }
//         },
//       );

//       debugPrint("✅ APK downloaded successfully, opening...");
//       Navigator.of(context).pop(); // ✅ close progress dialog
//       await OpenFilex.open(filePath); // install
//     } catch (e) {
//       Navigator.of(context).pop(); // ✅ close progress dialog on error
//       debugPrint("❌ Failed to download or install APK: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offlinebingo/config/_checkVersion.dart';
import 'package:provider/provider.dart';
import 'package:offlinebingo/ZeroApp/splash_page.dart';


/// Dev SSL override (optional)
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

class VersionCheckWrapper extends StatefulWidget {
  const VersionCheckWrapper({super.key});

  @override
  State<VersionCheckWrapper> createState() => _VersionCheckWrapperState();
}

class _VersionCheckWrapperState extends State<VersionCheckWrapper> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await UpdateService.checkForUpdate(context);

      // ✅ Continue to splash screen if no update required
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

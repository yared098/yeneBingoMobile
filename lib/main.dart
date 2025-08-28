

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
        title: 'Yene Bingo',
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

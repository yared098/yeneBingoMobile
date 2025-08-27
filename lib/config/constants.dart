import 'dart:ui';

import 'package:flutter/material.dart';

/// Game Constants for Offline Bingo Game powered by Abbisniya Soft
class GameConstants {
  /// Total number of bingo numbers (typically 75 or 90)
  static const int totalNumbers = 75;

  /// Bingo grid dimensions (default 5x5)
  static const int gridSize = 5;

  /// Interval (in seconds) between number calls in Auto mode
  static const int autoCallIntervalSeconds = 2;

  /// App title
  static const String appTitle = 'Offline Bingo - Abbisniya Soft';

  /// Sound assets
  static const String callSound = 'assets/sounds/call.mp3';
  static const String winSound = 'assets/sounds/win.mp3';

  /// Logo
  static const String logo = 'assets/images/logo.png';
}

const baseUrl = "https://your-api.com/api";
const loginEndpoint = "/auth/login";
const registerEndpoint = "/auth/register";

const Color primaryColor = Color(0xFF1E1E2E);
const Color errorColor = Colors.red;

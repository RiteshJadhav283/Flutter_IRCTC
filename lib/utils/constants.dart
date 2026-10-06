import 'package:flutter/material.dart';

/// RailGo Application Constants & Design System Tokens
/// Based on Modern Indian Transit Design System
class AppColors {
  // Primary Palette
  static const Color primaryBlue = Color(0xFF1A3C8F); // Railway Blue
  static const Color primaryDark = Color(0xFF0D2266);
  static const Color primaryLight = Color(0xFFE8EEF9);

  // Accent & CTA Palette
  static const Color accentOrange = Color(0xFFFF6B00); // IRCTC Accent Orange
  static const Color orangePressed = Color(0xFFE55A00);
  static const Color orangeLight = Color(0xFFFFF0E6);

  // Status & Availability Colors
  static const Color statusAvailable = Color(0xFF0D9488); // Emerald Teal
  static const Color statusAvailableBg = Color(0xFFE6F4EA);
  static const Color statusWaitlist = Color(0xFFD97706); // Amber WL/RAC
  static const Color statusWaitlistBg = Color(0xFFFEF3C7);
  static const Color statusRegret = Color(0xFFDC2626); // Crimson Red
  static const Color statusRegretBg = Color(0xFFFEE2E2);
  static const Color statusInfo = Color(0xFF1565C0);

  // Aliases for seat and badge colors per Idea.md
  static const Color seatAvailable = statusAvailable;
  static const Color seatWaitlist = statusWaitlist;
  static const Color seatOccupied = statusRegret;

  // Background & Surface
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFEDF2F7);

  // Typography
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF94A3B8);

  // Dark Mode Palette
  static const Color darkBackground = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkText = Color(0xFFF0F0FF);
}

class AppConstants {
  static const String appName = 'RailGo';
  static const String appTagline = 'Your Train. Your Way.';

  // Standard Spacings
  static const double gapXs = 4.0;
  static const double gapSm = 8.0;
  static const double gapMd = 16.0;
  static const double gapLg = 24.0;
  static const double gapXl = 32.0;

  // Radius Standards
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2Xl = 24.0;

  // Component Heights
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;

  // Pricing constants per Idea.md Section 10
  static const Map<String, double> baseFares = {
    'GEN': 150.0,
    '2S': 180.0,
    'SL': 350.0,
    'CC': 650.0,
    '3A': 850.0,
    '2A': 1250.0,
    '1A': 2250.0,
    'EC': 2450.0,
  };

  static const Map<String, double> tatkalCharges = {
    'GEN': 50.0,
    '2S': 50.0,
    'SL': 200.0,
    'CC': 225.0,
    '3A': 300.0,
    '2A': 350.0,
    '1A': 400.0,
    'EC': 450.0,
  };

  static const double gstRate = 0.05;
  static const double convenienceFee = 35.0;

  // Train Classes Map
  static const List<Map<String, String>> trainClasses = [
    {'code': 'ALL', 'name': 'All Classes'},
    {'code': '1A', 'name': '1A • AC First'},
    {'code': '2A', 'name': '2A • AC 2-Tier'},
    {'code': '3A', 'name': '3A • AC 3-Tier'},
    {'code': 'SL', 'name': 'SL • Sleeper'},
    {'code': 'CC', 'name': 'CC • AC Chair'},
    {'code': 'EC', 'name': 'EC • Exec Chair'},
    {'code': '2S', 'name': '2S • 2nd Sitting'},
    {'code': 'GEN', 'name': 'GEN • General'},
  ];

  // Quotas
  static const List<String> quotas = [
    'General',
    'Tatkal',
    'Premium Tatkal',
    'Ladies',
    'Senior Citizen',
  ];
}

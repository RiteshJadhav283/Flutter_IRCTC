import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _pnrDelayAlerts = true;
  bool _biometricUnlock = true;
  bool _autoDownloadTickets = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Appearance
            _SectionCard(
              title: 'APPEARANCE & THEME',
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryBlue),
                  title: const Text('Dark Theme Mode', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  subtitle: const Text('Switch between Light and Dark interface', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: theme.isDarkMode,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (v) => theme.toggleTheme(v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Security
            _SectionCard(
              title: 'SECURITY & BIOMETRICS',
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primaryBlue),
                  title: const Text('Fingerprint / Face ID Unlock', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  subtitle: const Text('Require biometric authentication on app launch', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: _biometricUnlock,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (v) => setState(() => _biometricUnlock = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Notifications
            _SectionCard(
              title: 'NOTIFICATIONS & FCM ALERTS',
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryBlue),
                  title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  subtitle: const Text('Receive booking confirmations and ticket updates', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: _pushNotifications,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.alarm_on_outlined, color: AppColors.accentOrange),
                  title: const Text('Live PNR Delay & Chart Alerts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  subtitle: const Text('Instant alert 4h before departure when chart is prepared', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: _pnrDelayAlerts,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (v) => setState(() => _pnrDelayAlerts = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Offline Storage
            _SectionCard(
              title: 'OFFLINE TICKETS STORAGE',
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.offline_pin_outlined, color: AppColors.primaryBlue),
                  title: const Text('Auto-Download Tickets (Hive DB)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  subtitle: const Text('Automatically cache confirmed e-tickets for offline display', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  value: _autoDownloadTickets,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (v) => setState(() => _autoDownloadTickets = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // App Info
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Text('RailGo IRCTC v3.0.0 (Production Build)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  SizedBox(height: 4),
                  Text('Developed for ITM Skills University — B.Tech CSE (AI)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

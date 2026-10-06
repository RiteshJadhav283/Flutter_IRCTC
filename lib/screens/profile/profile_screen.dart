import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;
    final isGuest = user == null || (user.email.isEmpty && user.phone.isEmpty);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile & Settings', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                          : 'GP',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null && user.name.isNotEmpty ? user.name : 'Guest Passenger',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        if (user != null && user.email.isNotEmpty)
                          Text(user.email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        if (user != null && user.phone.isNotEmpty)
                          Text(user.phone, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (user?.irctcUserId != null && user!.irctcUserId!.isNotEmpty)
                                ? 'IRCTC ID: ${user.irctcUserId} (Verified)'
                                : (isGuest ? 'Guest Access' : 'Verified Firebase User'),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (isGuest) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.accentOrange, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Browsing as Guest', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF92400E))),
                          SizedBox(height: 2),
                          Text('Sign in to save tickets permanently and sync passenger list.', style: TextStyle(fontSize: 11, color: Color(0xFFB45309))),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (r) => false,
                        );
                      },
                      child: const Text('Sign In', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Saved Passengers Section
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SAVED PASSENGERS (MASTER LIST)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddPassengerDialog(context, auth),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add New', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (user == null || user.savedPassengers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No saved passengers. Add passengers for 1-tap fast Tatkal checkout.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      )
                    else
                      ...user.savedPassengers.map((p) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFF1F5F9),
                            child: Icon(Icons.person, color: AppColors.primaryBlue, size: 20),
                          ),
                          title: Text(p.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          subtitle: Text('${p.age} yrs • ${p.gender} • ${p.berthPreference}', style: const TextStyle(fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.seatOccupied, size: 18),
                            onPressed: () => auth.removeSavedPassenger(p.id),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // App Settings
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Default is Light for sunlight readability (per Idea.md)', style: TextStyle(fontSize: 11)),
                    value: theme.isDarkMode,
                    onChanged: (val) => theme.toggleTheme(val),
                    activeColor: AppColors.primaryBlue,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.fingerprint_rounded, color: AppColors.primaryBlue),
                    title: const Text('Biometric Login (Touch ID / Face ID)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.check_circle, color: AppColors.seatAvailable, size: 20),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppColors.primaryBlue),
                    title: const Text('About RailGo & Project Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'RailGo',
                        applicationVersion: 'v3.0 Master',
                        applicationLegalese: 'ITM Skills University — B.Tech CSE (AI)\nSemester V — Cross Platform Mobile Development\nArchitected with Flutter, Provider, & Firebase.',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sign Out / Log In Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.seatOccupied,
                side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(
                isGuest ? 'Exit Guest Mode & Sign In' : 'Sign Out from RailGo',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              onPressed: () async {
                await auth.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (r) => false,
                  );
                }
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showAddPassengerDialog(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    String gender = 'Male';
    String berth = 'Lower Berth (LB)';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Saved Passenger', style: TextStyle(fontWeight: FontWeight.w800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: gender,
                items: ['Male', 'Female', 'Transgender'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) {
                  if (val != null) setDState(() => gender = val);
                },
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: berth,
                items: [
                  'Lower Berth (LB)',
                  'Middle Berth (MB)',
                  'Upper Berth (UB)',
                  'Side Lower (SL)',
                  'Side Upper (SU)',
                  'No Preference',
                ].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (val) {
                  if (val != null) setDState(() => berth = val);
                },
                decoration: const InputDecoration(labelText: 'Berth Preference'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  auth.addSavedPassenger(
                    SavedPassenger(
                      id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text,
                      age: int.tryParse(ageCtrl.text) ?? 25,
                      gender: gender,
                      berthPreference: berth,
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save Passenger', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

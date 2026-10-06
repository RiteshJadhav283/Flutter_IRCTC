import 'package:flutter/material.dart';
import '../../services/mock_data.dart';
import '../../utils/constants.dart';
import 'booking_detail_screen.dart';

class OfflineTicketsScreen extends StatelessWidget {
  const OfflineTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offlineBookings = MockData.defaultBookings.where((b) => b.isDownloaded).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offline Saved Tickets', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: offlineBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_off_rounded, size: 36, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  const Text('No Offline Tickets Saved', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  const Text('Downloaded e-tickets will appear here and can be opened without internet.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offlineBookings.length,
              itemBuilder: (context, index) {
                final b = offlineBookings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.offline_pin_rounded, color: AppColors.primaryBlue),
                    ),
                    title: Text('${b.trainName} (${b.trainNumber})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: Text('PNR: ${b.pnr} • ${b.source} -> ${b.destination}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: b)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

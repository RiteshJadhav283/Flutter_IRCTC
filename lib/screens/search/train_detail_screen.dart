import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/train_model.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../booking/coach_layout_screen.dart';

class TrainDetailScreen extends StatelessWidget {
  final Train train;

  const TrainDetailScreen({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${train.trainNumber} • ${train.trainName}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Train Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(train.departureTime, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(train.source, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(train.duration, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
                          Container(
                            width: 80,
                            height: 2,
                            color: AppColors.borderLight,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          const Text('Direct Express', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(train.arrivalTime, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(train.destination, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _AmenityBadge(icon: Icons.restaurant_rounded, label: train.hasFoodService ? 'Pantry Car' : 'No Pantry', active: train.hasFoodService),
                      _AmenityBadge(icon: Icons.bolt_rounded, label: 'E-Catering', active: true),
                      _AmenityBadge(icon: Icons.cleaning_services_rounded, label: 'OBHS Clean', active: true),
                      _AmenityBadge(icon: Icons.security_rounded, label: 'RPF Escort', active: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Running Days Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RUNS ON', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                      final isRunning = train.runningDays.contains(day) || train.runningDays.contains('Daily');
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isRunning ? AppColors.primaryBlue : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isRunning ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Route & Intermediate Stops Timeline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('STATIONS & SCHEDULE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
                  const SizedBox(height: 16),
                  _RouteTimelineTile(
                    station: train.source,
                    code: train.source,
                    time: train.departureTime,
                    distance: '0 km',
                    isFirst: true,
                    isLast: false,
                    platform: 'PF 1',
                  ),
                  _RouteTimelineTile(
                    station: 'Intermediate Halt 1',
                    code: 'HALT1',
                    time: '18:45',
                    distance: '340 km',
                    isFirst: false,
                    isLast: false,
                    platform: 'PF 3',
                  ),
                  _RouteTimelineTile(
                    station: 'Intermediate Halt 2',
                    code: 'HALT2',
                    time: '23:15',
                    distance: '780 km',
                    isFirst: false,
                    isLast: false,
                    platform: 'PF 2',
                  ),
                  _RouteTimelineTile(
                    station: train.destination,
                    code: train.destination,
                    time: train.arrivalTime,
                    distance: '1,384 km',
                    isFirst: false,
                    isLast: true,
                    platform: 'PF 4',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight, width: 1.2)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentOrange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            context.read<BookingProvider>().startBookingFlow(
              train: train,
              travelClass: '3A',
              date: DateTime.now().add(const Duration(days: 1)),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoachLayoutScreen()),
            );
          },
          child: const Text('Proceed to Select Seats', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
      ),
    );
  }
}

class _AmenityBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _AmenityBadge({required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: active ? AppColors.primaryBlue : AppColors.textMuted),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: active ? AppColors.textPrimary : AppColors.textMuted)),
      ],
    );
  }
}

class _RouteTimelineTile extends StatelessWidget {
  final String station;
  final String code;
  final String time;
  final String distance;
  final String platform;
  final bool isFirst;
  final bool isLast;

  const _RouteTimelineTile({
    required this.station,
    required this.code,
    required this.time,
    required this.distance,
    required this.platform,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isFirst || isLast) ? AppColors.primaryBlue : AppColors.accentOrange,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.borderLight,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$station ($code)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Text(time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(platform, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  Text(distance, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

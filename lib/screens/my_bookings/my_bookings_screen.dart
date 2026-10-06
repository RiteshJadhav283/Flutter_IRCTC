import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../utils/constants.dart';
import '../booking/booking_confirmation_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final all = bookingProvider.bookings;

    final upcoming = all.where((b) => b.status == 'CONFIRMED' && b.journeyDate.isAfter(DateTime.now().subtract(const Duration(days: 1)))).toList();
    final completed = all.where((b) => b.status == 'CONFIRMED' && b.journeyDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))).toList();
    final cancelled = all.where((b) => b.status == 'CANCELLED').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.w800)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Upcoming (${upcoming.length})'),
            Tab(text: 'Completed (${completed.length})'),
            Tab(text: 'Cancelled (${cancelled.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(upcoming, bookingProvider, isUpcoming: true),
          _buildBookingList(completed, bookingProvider),
          _buildBookingList(cancelled, bookingProvider, isCancelled: true),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Booking> list, BookingProvider provider, {bool isUpcoming = false, bool isCancelled = false}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.airplane_ticket_outlined, size: 64, color: AppColors.textHint),
            SizedBox(height: 12),
            Text(
              'No tickets found in this tab',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final dateFormat = DateFormat('EEE, d MMM yyyy');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final b = list[i];
        final p = b.passengers.first;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'PNR: ${b.pnr}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryBlue),
                            ),
                            const SizedBox(width: 8),
                            if (b.isDownloaded)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Offline',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
                                ),
                              ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isCancelled
                                ? AppColors.statusRegretBg
                                : AppColors.statusAvailableBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            b.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isCancelled ? AppColors.statusRegret : AppColors.statusAvailable,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${b.trainNumber} ${b.trainName}',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${b.source} → ${b.destination} • ${dateFormat.format(b.journeyDate)}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Coach ${p.coachNumber ?? "B4"}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Berth ${p.berthNumber ?? "37"} (${p.berthType ?? "SL"})',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons bar
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BookingConfirmationScreen(booking: b),
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code_rounded, size: 16),
                      label: const Text('View Digital Pass', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    if (isUpcoming)
                      TextButton(
                        onPressed: () => _confirmCancelBooking(context, b, provider),
                        child: const Text(
                          'Cancel Ticket',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.statusRegret),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmCancelBooking(BuildContext context, Booking b, BookingProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Ticket?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel booking PNR ${b.pnr}?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Refund Preview (Per Idea.md slab):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Total Paid: ₹${b.fareDetails.totalFare.toInt()}'),
                  const Text('Deduction (>48 hrs): 15% (₹278)'),
                  Text(
                    'Refund to source: ₹${(b.fareDetails.totalFare * 0.85).toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.statusAvailable),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Ticket')),
          ElevatedButton(
            onPressed: () {
              provider.cancelBooking(b.pnr);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ticket cancelled. Refund initiated!'), behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusRegret),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/coach_seat_widget.dart';
import 'passenger_details_screen.dart';

class CoachLayoutScreen extends StatelessWidget {
  const CoachLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final train = booking.train;
    final selectedClass = booking.selectedClass;
    final coaches = ['B1', 'B2', 'B3', 'B4', 'B5', 'B6'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Berths / Seats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              '${train?.trainNumber ?? "12952"} ${train?.trainName ?? "Rajdhani"} • $selectedClass',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Coach Selector Carousel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SELECT COACH (${selectedClass == "3A" ? "AC 3 Tier" : "AC 2 Tier"})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Text(
                          '8th from Engine • Near Pantry',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: coaches.length,
                    itemBuilder: (ctx, i) {
                      final c = coaches[i];
                      final isSelected = c == booking.selectedCoach;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => booking.selectCoach(c),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryBlue : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryBlue : AppColors.borderLight,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryBlue.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$c ${isSelected ? "(18 Avl)" : ""}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Berth Status Legend
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Available', AppColors.statusAvailableBg, AppColors.statusAvailable),
                _buildLegendItem('Selected', AppColors.accentOrange, Colors.white),
                _buildLegendItem('Booked', const Color(0xFFF1F5F9), const Color(0xFF94A3B8)),
                _buildLegendItem('Ladies', const Color(0xFFF3E8FF), const Color(0xFF7E22CE)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Visual Coach Interior Map (Blueprint)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Coach Front / Vestibule
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.meeting_room_outlined, size: 16, color: AppColors.textSecondary),
                            SizedBox(width: 6),
                            Text('Coach Entrance / Vestibule', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.wc_outlined, size: 16, color: AppColors.textSecondary),
                            SizedBox(width: 4),
                            Text('Restroom', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Cabin Bays with Staggered Entrance
                  _buildCabinBay(
                    bayNumber: 5,
                    leftBerths: [
                      {'no': 31, 'code': 'LB', 'occ': true},
                      {'no': 32, 'code': 'MB', 'occ': true},
                      {'no': 33, 'code': 'UB', 'occ': false},
                      {'no': 34, 'code': 'LB', 'occ': false},
                      {'no': 35, 'code': 'MB', 'occ': false},
                      {'no': 36, 'code': 'UB', 'occ': true},
                    ],
                    sideBerths: [
                      {'no': 37, 'code': 'SL', 'occ': false},
                      {'no': 38, 'code': 'SU', 'occ': false},
                    ],
                    booking: booking,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 16),

                  _buildCabinBay(
                    bayNumber: 6,
                    leftBerths: [
                      {'no': 39, 'code': 'LB', 'occ': false},
                      {'no': 40, 'code': 'MB', 'occ': true},
                      {'no': 41, 'code': 'UB', 'occ': false},
                      {'no': 42, 'code': 'LB', 'occ': true},
                      {'no': 43, 'code': 'MB', 'occ': false},
                      {'no': 44, 'code': 'UB', 'occ': false},
                    ],
                    sideBerths: [
                      {'no': 45, 'code': 'SL', 'occ': false},
                      {'no': 46, 'code': 'SU', 'occ': true},
                    ],
                    booking: booking,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideY(begin: 0.05, end: 0),

                  const SizedBox(height: 12),

                  // Coach Rear
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 6),
                        Text('Towards Pantry Car & Next Coach', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Selected Berth & Summary Card
          _buildSelectedBerthSummary(context, booking),

          // Bottom Fixed Action Bar
          _buildBottomAction(context, booking),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color bg, Color text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: text.withOpacity(0.5)),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCabinBay({
    required int bayNumber,
    required List<Map<String, dynamic>> leftBerths,
    required List<Map<String, dynamic>> sideBerths,
    required BookingProvider booking,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CABIN BAY $bayNumber',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBlue,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Left Bay: 6 berths (3x2 grid)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildSeatItem(leftBerths[0], booking)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSeatItem(leftBerths[1], booking)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSeatItem(leftBerths[2], booking)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildSeatItem(leftBerths[3], booking)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSeatItem(leftBerths[4], booking)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildSeatItem(leftBerths[5], booking)),
                      ],
                    ),
                  ],
                ),
              ),

              // Aisle separator
              Container(
                width: 32,
                height: 90,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'AISLE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textHint,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Bay: 2 berths (Side Lower & Side Upper)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildSeatItem(sideBerths[0], booking),
                    const SizedBox(height: 8),
                    _buildSeatItem(sideBerths[1], booking),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatItem(Map<String, dynamic> data, BookingProvider booking) {
    final int no = data['no'];
    final String code = data['code'];
    final bool isOcc = data['occ'];
    final bool isSel = booking.selectedBerths.containsKey(no);

    return CoachSeatWidget(
      berthNumber: no,
      berthCode: code,
      isSelected: isSel,
      isOccupied: isOcc,
      onTap: () {
        booking.toggleBerth(no, code);
      },
    );
  }

  Widget _buildSelectedBerthSummary(BuildContext context, BookingProvider booking) {
    final berthsList = booking.selectedBerths.entries.map((e) => 'Berth ${e.key} (${e.value})').join(', ');

    return Container(
      color: const Color(0xFFEFF6FF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.chair_alt_rounded, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Allocated Berths', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryBlue)),
                  Text(
                    'Coach ${booking.selectedCoach} • ${berthsList.isEmpty ? "No berth selected" : berthsList}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Text(
              '${booking.selectedBerths.length} Selected',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, BookingProvider booking) {
    final fare = booking.fareDetails;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'TOTAL FARE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
                Text(
                  '₹${fare.totalFare.toInt()}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Includes GST & charges',
                  style: TextStyle(fontSize: 10, color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const PassengerDetailsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Continue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

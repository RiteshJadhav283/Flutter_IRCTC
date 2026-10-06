import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/train_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/station_selector_sheet.dart';
import '../search/train_list_screen.dart';
import '../pnr/pnr_status_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _swapController;
  double _swapAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _swapController.dispose();
    super.dispose();
  }

  void _handleSwapStations(TrainProvider provider) {
    setState(() {
      _swapAngle += 3.141592653589793; // 180 degrees
    });
    provider.swapStations();
  }

  @override
  Widget build(BuildContext context) {
    final trainProvider = context.watch<TrainProvider>();
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Bar
              _buildTopHeader(context)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),

              const SizedBox(height: 16),

              // Hero Train Search Card
              _buildSearchCard(context, trainProvider)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

              const SizedBox(height: 20),

              // Live Upcoming Journey Card (if any upcoming confirmed booking)
              _buildUpcomingJourneyCard(context, bookingProvider)
                  .animate()
                  .fadeIn(duration: 450.ms, delay: 200.ms)
                  .slideY(begin: 0.06, end: 0),

              const SizedBox(height: 20),

              // Quick Services Grid (4 action tiles)
              _buildQuickServicesGrid(context)
                  .animate()
                  .fadeIn(duration: 450.ms, delay: 300.ms),

              const SizedBox(height: 20),

              // IRCTC Smart Tatkal & Official Partner Advisory Banner
              _buildPartnerBanner(context)
                  .animate()
                  .fadeIn(duration: 450.ms, delay: 400.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.train_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Rail',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'Go',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentOrange,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Text(
                        'IRCTC Verified',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Namaste, Ritesh',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Badge(
                  backgroundColor: AppColors.accentOrange,
                  smallSize: 8,
                  child: Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All services operating normally. Your schedule is on time!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchCard(BuildContext context, TrainProvider provider) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfter = today.add(const Duration(days: 2));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radius2Xl),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Station Selection with Interactive Animated Swap Button
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  // From Station
                  InkWell(
                    onTap: () {
                      StationSelectorSheet.show(
                        context,
                        title: 'Select Departure Station',
                        currentStation: provider.source,
                        onSelect: (s) => provider.setSource(s),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.trip_origin_rounded, color: AppColors.primaryBlue, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'FROM',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textHint,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${provider.source.city} (${provider.source.code})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  provider.source.name,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // To Station
                  InkWell(
                    onTap: () {
                      StationSelectorSheet.show(
                        context,
                        title: 'Select Destination Station',
                        currentStation: provider.destination,
                        onSelect: (s) => provider.setDestination(s),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.location_on_rounded, color: AppColors.accentOrange, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textHint,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${provider.destination.city} (${provider.destination.code})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  provider.destination.name,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Animated Swap Button
              Positioned(
                right: 20,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: _swapAngle),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutBack,
                  builder: (context, angle, child) {
                    return Transform.rotate(
                      angle: angle,
                      child: child,
                    );
                  },
                  child: InkWell(
                    onTap: () => _handleSwapStations(provider),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.swap_vert_rounded, color: AppColors.primaryBlue, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date Selector
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: provider.journeyDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 120)),
              );
              if (picked != null) {
                provider.setDate(picked);
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_month_rounded, color: AppColors.primaryBlue, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEPARTURE DATE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHint,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateFormat.format(provider.journeyDate),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Quick Date Chips (Today, Tomorrow, Day After)
          Row(
            children: [
              _buildDateChip('Today', today, provider),
              const SizedBox(width: 8),
              _buildDateChip('Tomorrow', tomorrow, provider),
              const SizedBox(width: 8),
              _buildDateChip('Day After', dayAfter, provider),
            ],
          ),

          const SizedBox(height: 14),

          // Quota & Class Selector
          Row(
            children: [
              // Class dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.selectedClass,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      items: AppConstants.trainClasses.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['code'],
                          child: Text(
                            item['name']!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) provider.setSelectedClass(val);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Quota dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.selectedQuota,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      items: AppConstants.quotas.map((q) {
                        return DropdownMenuItem<String>(
                          value: q,
                          child: Text(
                            q,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) provider.setSelectedQuota(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Primary CTA: Search Trains with subtle pulse shimmer
          ElevatedButton(
            onPressed: () {
              provider.searchTrains();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const TrainListScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              elevation: 4,
              shadowColor: AppColors.accentOrange.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.search_rounded, size: 22),
                SizedBox(width: 8),
                Text(
                  'Search Trains',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2500.ms, color: Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }

  Widget _buildDateChip(String label, DateTime date, TrainProvider provider) {
    final isSelected = DateUtils.isSameDay(provider.journeyDate, date);

    return Expanded(
      child: InkWell(
        onTap: () => provider.setDate(date),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingJourneyCard(BuildContext context, BookingProvider bookingProvider) {
    if (bookingProvider.bookings.isEmpty) return const SizedBox.shrink();
    final booking = bookingProvider.bookings.first;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.statusAvailable,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: 1000.ms),
                  const SizedBox(width: 8),
                  const Text(
                    'UPCOMING JOURNEY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.statusAvailableBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PNR: ${booking.pnr}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.statusAvailable,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${booking.trainNumber} ${booking.trainName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${booking.source} (${booking.departureTime}) → ${booking.destination} (${booking.arrivalTime})',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                '${booking.passengers.first.coachNumber}-${booking.passengers.first.berthNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status: Confirmed (CNF)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.statusAvailable),
              ),
              InkWell(
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(2); // Navigate to My Bookings
                  }
                },
                child: Row(
                  children: const [
                    Text(
                      'View Boarding Pass',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentOrange,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.accentOrange),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickServicesGrid(BuildContext context) {
    final services = [
      {
        'title': 'Live Status',
        'subtitle': 'Track GPS',
        'icon': Icons.radar_rounded,
        'iconColor': const Color(0xFF0284C7),
        'bgColor': const Color(0xFFF0F9FF),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const PNRStatusScreen()),
          );
        },
      },
      {
        'title': 'PNR Enquiry',
        'subtitle': 'Instant Chart',
        'icon': Icons.confirmation_number_rounded,
        'iconColor': AppColors.accentOrange,
        'bgColor': const Color(0xFFFFF7ED),
        'onTap': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3); // Navigate to PNR tab
          }
        },
      },
      {
        'title': 'Coach Position',
        'subtitle': 'Platform Layout',
        'icon': Icons.view_column_rounded,
        'iconColor': const Color(0xFF7C3AED),
        'bgColor': const Color(0xFFF5F3FF),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coach B4 is 8th from locomotive engine.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      },
      {
        'title': 'Order Food',
        'subtitle': 'IRCTC e-Catering',
        'icon': Icons.fastfood_rounded,
        'iconColor': const Color(0xFFD97706),
        'bgColor': const Color(0xFFFFFBEB),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('IRCTC e-Catering hot meals available at Kota & Vadodara Jn.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK SERVICES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildServiceTile(services[0], 0),
            const SizedBox(width: 10),
            _buildServiceTile(services[1], 1),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildServiceTile(services[2], 2),
            const SizedBox(width: 10),
            _buildServiceTile(services[3], 3),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceTile(Map<String, dynamic> s, int index) {
    return Expanded(
      child: InkWell(
        onTap: s['onTap'] as VoidCallback,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: s['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(s['icon'] as IconData, color: s['iconColor'] as Color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['title'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      s['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: (200 + index * 60).ms, duration: 350.ms)
          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutBack),
    );
  }

  Widget _buildPartnerBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flash_on_rounded, color: Color(0xFFFBBF24), size: 26)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1200.ms),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tatkal Booking Advisory',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'AC Tatkal opens at 10:00 AM • Non-AC at 11:00 AM daily. Enjoy 0% gateway charges.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

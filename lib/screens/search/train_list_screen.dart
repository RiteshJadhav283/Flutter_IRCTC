import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/train_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/train_card.dart';
import '../booking/coach_layout_screen.dart';

class TrainListScreen extends StatefulWidget {
  const TrainListScreen({super.key});

  @override
  State<TrainListScreen> createState() => _TrainListScreenState();
}

class _TrainListScreenState extends State<TrainListScreen> {
  String _selectedClassInView = '3A';

  @override
  Widget build(BuildContext context) {
    final trainProvider = context.watch<TrainProvider>();
    final bookingProvider = context.read<BookingProvider>();
    final trains = trainProvider.searchResults;
    final dateFormat = DateFormat('EEE, d MMM');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${trainProvider.source.code} → ${trainProvider.destination.code}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              '${dateFormat.format(trainProvider.journeyDate)} • ${trainProvider.selectedQuota} Quota',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primaryBlue),
            onPressed: () => _showFilterModal(context, trainProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal Day Selector Strip
          _buildDateSelectorStrip(context, trainProvider),

          // Quick Filter Chips Row
          _buildFilterChipsRow(context, trainProvider),

          const SizedBox(height: 8),

          // Search Results Counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${trains.length} trains available',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Sorted: ${trainProvider.sortBy.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Trains List with staggered entrance
          Expanded(
            child: trains.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.train_outlined, size: 54, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        const Text(
                          'No trains found for selected criteria',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            trainProvider.toggleAvailableOnly();
                          },
                          child: const Text('Reset Availability Filter'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    physics: const BouncingScrollPhysics(),
                    itemCount: trains.length,
                    itemBuilder: (ctx, i) {
                      final train = trains[i];
                      return TrainCard(
                        train: train,
                        selectedClass: _selectedClassInView,
                        onClassSelected: (classCode) {
                          setState(() {
                            _selectedClassInView = classCode;
                          });
                        },
                        onBookNow: () {
                          bookingProvider.startBookingFlow(
                            train: train,
                            travelClass: _selectedClassInView,
                            date: trainProvider.journeyDate,
                            quota: trainProvider.selectedQuota,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const CoachLayoutScreen(),
                            ),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(delay: (i * 70).ms, duration: 350.ms)
                          .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
                    },
                  ),
          ),
        ],
      ),
      // Floating Bottom Sort & Filter Pill Bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _showSortModal(context, trainProvider),
              child: Row(
                children: [
                  const Icon(Icons.sort_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Sort: ${trainProvider.sortBy.toUpperCase()}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 1,
              color: Colors.white24,
              margin: const EdgeInsets.symmetric(horizontal: 14),
            ),
            InkWell(
              onTap: () => _showFilterModal(context, trainProvider),
              child: Row(
                children: const [
                  Icon(Icons.tune_rounded, color: Color(0xFFFBBF24), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Filters',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: 300.ms, duration: 400.ms)
          .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
    );
  }

  Widget _buildDateSelectorStrip(BuildContext context, TrainProvider provider) {
    final baseDate = DateTime.now();

    return Container(
      height: 64,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 14,
        itemBuilder: (ctx, i) {
          final date = baseDate.add(Duration(days: i));
          final isSelected = DateUtils.isSameDay(provider.journeyDate, date);
          final dayName = DateFormat('E').format(date);
          final dayNum = DateFormat('d MMM').format(date);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => provider.setDate(date),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 78,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : AppColors.borderLight,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayName, $dayNum',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹615+',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF93C5FD) : AppColors.statusAvailable,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChipsRow(BuildContext context, TrainProvider provider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('Available Only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              selected: provider.availableOnly,
              onSelected: (_) => provider.toggleAvailableOnly(),
              selectedColor: AppColors.statusAvailableBg,
              checkmarkColor: AppColors.statusAvailable,
              backgroundColor: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(width: 8),
            ActionChip(
              label: Text('Class: ${provider.selectedClass}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              backgroundColor: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                _showClassPicker(context, provider);
              },
            ),
            const SizedBox(width: 8),
            ActionChip(
              label: const Text('Fastest First', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              backgroundColor: provider.sortBy == 'duration' ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                provider.setSortBy(provider.sortBy == 'duration' ? 'departure' : 'duration');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortModal(BuildContext context, TrainProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Trains By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.access_time_rounded),
              title: const Text('Departure Time (Earliest First)'),
              trailing: provider.sortBy == 'departure' ? const Icon(Icons.check, color: AppColors.primaryBlue) : null,
              onTap: () {
                provider.setSortBy('departure');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Duration (Fastest First)'),
              trailing: provider.sortBy == 'duration' ? const Icon(Icons.check, color: AppColors.primaryBlue) : null,
              onTap: () {
                provider.setSortBy('duration');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context, TrainProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter Trains', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  TextButton(
                    onPressed: () {
                      provider.setSelectedClass('ALL');
                      if (provider.availableOnly) provider.toggleAvailableOnly();
                      Navigator.pop(ctx);
                    },
                    child: const Text('Reset All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Show Available Seats Only', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Hide fully booked or waitlisted trains', style: TextStyle(fontSize: 12)),
                value: provider.availableOnly,
                onChanged: (val) {
                  provider.toggleAvailableOnly();
                  setMState(() {});
                },
                activeColor: AppColors.statusAvailable,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClassPicker(BuildContext context, TrainProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter by Class', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.trainClasses.map((c) {
                final isSel = provider.selectedClass == c['code'];
                return ChoiceChip(
                  label: Text(c['name']!),
                  selected: isSel,
                  onSelected: (val) {
                    if (val) {
                      provider.setSelectedClass(c['code']!);
                      Navigator.pop(ctx);
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

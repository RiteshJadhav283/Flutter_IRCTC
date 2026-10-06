import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/train_model.dart';
import '../utils/constants.dart';

class TrainCard extends StatelessWidget {
  final Train train;
  final String selectedClass;
  final Function(String classCode) onClassSelected;
  final VoidCallback onBookNow;
  final VoidCallback? onCardTap;

  const TrainCard({
    super.key,
    required this.train,
    required this.selectedClass,
    required this.onClassSelected,
    required this.onBookNow,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCardTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Train Number, Name, Type Badge & Live On-Time Tag
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                train.trainNumber,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBlue,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: train.trainType.contains('Vande')
                                      ? const Color(0xFFEFF6FF)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: train.trainType.contains('Vande')
                                        ? const Color(0xFF93C5FD)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  train.trainType,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: train.trainType.contains('Vande')
                                        ? AppColors.primaryBlue
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            train.trainName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Punctuality Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusAvailableBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, size: 12, color: AppColors.statusAvailable),
                          const SizedBox(width: 4),
                          Text(
                            '${train.punctualityPercent.toStringAsFixed(0)}% On-Time',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.statusAvailable,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Departure -> Duration -> Arrival Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Source
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          train.departureTime,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${train.source} • Pf ${train.departurePlatform}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Duration track with moving train shimmer animation
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              train.duration,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.5,
                                    color: AppColors.divider,
                                  ),
                                ),
                                const Icon(Icons.train, size: 15, color: AppColors.primaryBlue)
                                    .animate(onPlay: (c) => c.repeat(reverse: true))
                                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.15, 1.15), duration: 1200.ms),
                                Expanded(
                                  child: Container(
                                    height: 1.5,
                                    color: AppColors.divider,
                                  ),
                                ),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${train.stops.length > 1 ? train.stops.length - 1 : 4} halts',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Destination
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          train.arrivalTime,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${train.destination} • Pf ${train.arrivalPlatform}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Perforated dashed divider
                Row(
                  children: List.generate(
                    28,
                    (index) => Expanded(
                      child: Container(
                        height: 1.2,
                        color: index.isEven ? AppColors.divider : Colors.transparent,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Class Selection Sub-cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: train.classes.entries.map((entry) {
                      final code = entry.key;
                      final info = entry.value;
                      final isSelected = selectedClass == code;

                      Color badgeBg;
                      Color badgeText;
                      String statusText;

                      if (info.status == 'AVAILABLE') {
                        badgeBg = AppColors.statusAvailableBg;
                        badgeText = AppColors.statusAvailable;
                        statusText = 'AVL ${info.availableSeats}';
                      } else if (info.status == 'RAC') {
                        badgeBg = AppColors.statusWaitlistBg;
                        badgeText = AppColors.statusWaitlist;
                        statusText = 'RAC ${info.waitlistCount}';
                      } else if (info.status == 'WL') {
                        badgeBg = AppColors.statusWaitlistBg;
                        badgeText = AppColors.statusWaitlist;
                        statusText = 'WL ${info.waitlistCount}';
                      } else {
                        badgeBg = AppColors.statusRegretBg;
                        badgeText = AppColors.statusRegret;
                        statusText = 'REGRET';
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => onClassSelected(code),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 106,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.accentOrange : AppColors.divider,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accentOrange.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      code,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppColors.accentOrange
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '₹${info.price.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: badgeText,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 14),

                // Booking Action Bar for selected class
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Amenity icons
                    Row(
                      children: [
                        if (train.hasPantry)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.restaurant, size: 16, color: AppColors.textMuted),
                          ),
                        if (train.hasFoodService)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.room_service, size: 16, color: AppColors.textMuted),
                          ),
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.power, size: 16, color: AppColors.textMuted),
                        ),
                        const Icon(Icons.wifi, size: 16, color: AppColors.textMuted),
                      ],
                    ),

                    // Book Now CTA
                    ElevatedButton(
                      onPressed: onBookNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        minimumSize: const Size(130, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Select & Book', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

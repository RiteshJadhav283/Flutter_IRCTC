import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CoachSeatWidget extends StatelessWidget {
  final int berthNumber;
  final String berthCode; // 'LB', 'MB', 'UB', 'SL', 'SU'
  final bool isSelected;
  final bool isOccupied;
  final bool isFemale;
  final VoidCallback onTap;

  const CoachSeatWidget({
    super.key,
    required this.berthNumber,
    required this.berthCode,
    required this.isSelected,
    required this.isOccupied,
    this.isFemale = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isSelected) {
      bgColor = AppColors.accentOrange;
      borderColor = AppColors.orangePressed;
      textColor = Colors.white;
    } else if (isOccupied) {
      bgColor = const Color(0xFFF1F5F9);
      borderColor = const Color(0xFFE2E8F0);
      textColor = const Color(0xFF94A3B8);
    } else if (isFemale) {
      bgColor = const Color(0xFFF3E8FF);
      borderColor = const Color(0xFFD8B4FE);
      textColor = const Color(0xFF7E22CE);
    } else {
      bgColor = AppColors.statusAvailableBg;
      borderColor = AppColors.statusAvailable.withOpacity(0.3);
      textColor = AppColors.statusAvailable;
    }

    return InkWell(
      onTap: isOccupied ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$berthNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 2),
                  const Icon(Icons.check_circle, size: 12, color: Colors.white),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              berthCode,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.9),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

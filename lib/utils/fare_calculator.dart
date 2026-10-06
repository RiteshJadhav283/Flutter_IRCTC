import 'constants.dart';

class FareCalculator {
  /// Calculate dynamic fare including base fare, quota surcharges, GST, and convenience fees
  static double calculateFare({
    required String travelClass,
    required String quota,
    required int passengerCount,
  }) {
    final baseFare = AppConstants.baseFares[travelClass] ?? 650.0;
    final tatkalCharge = quota == 'Tatkal'
        ? (AppConstants.tatkalCharges[travelClass] ?? 200.0)
        : 0.0;

    final subtotal = (baseFare + tatkalCharge) * passengerCount;
    final gst = subtotal * AppConstants.gstRate;
    final total = subtotal + gst + AppConstants.convenienceFee;

    return total;
  }

  /// Calculate refund amount based on IRCTC cancellation rules
  static double calculateRefund({
    required double totalPaid,
    required String travelClass,
    required int hoursBeforeDeparture,
  }) {
    double cancellationFee;

    if (hoursBeforeDeparture > 48) {
      switch (travelClass) {
        case '1A':
        case 'EC':
          cancellationFee = 240.0;
          break;
        case '2A':
          cancellationFee = 200.0;
          break;
        case '3A':
        case 'CC':
          cancellationFee = 180.0;
          break;
        case 'SL':
          cancellationFee = 120.0;
          break;
        default:
          cancellationFee = 60.0;
      }
    } else if (hoursBeforeDeparture >= 12) {
      cancellationFee = totalPaid * 0.25; // 25% of fare
    } else if (hoursBeforeDeparture >= 4) {
      cancellationFee = totalPaid * 0.50; // 50% of fare
    } else {
      cancellationFee = totalPaid; // No refund within 4 hours
    }

    final refund = totalPaid - cancellationFee;
    return refund > 0 ? refund : 0.0;
  }
}

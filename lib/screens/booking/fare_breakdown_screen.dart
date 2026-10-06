import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import 'payment_screen.dart';

class FareBreakdownScreen extends StatefulWidget {
  const FareBreakdownScreen({super.key});

  @override
  State<FareBreakdownScreen> createState() => _FareBreakdownScreenState();
}

class _FareBreakdownScreenState extends State<FareBreakdownScreen> {
  bool _includeLounge = false;
  bool _includeTravelInsurance = true;

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final fare = booking.fareDetails;
    final passengersCount = booking.passengers.length;

    final baseFare = fare?.baseFare ?? 1700.0;
    final tatkalCharge = fare?.tatkalCharge ?? (booking.isTatkal ? 600.0 : 0.0);
    final gst = fare?.serviceTax ?? (baseFare * 0.05);
    final convenienceFee = fare?.convenienceFee ?? 35.0;
    final loungeCost = _includeLounge ? (passengersCount * 250.0) : 0.0;
    final insuranceCost = _includeTravelInsurance ? (passengersCount * 0.45) : 0.0;
    final grandTotal = baseFare + tatkalCharge + gst + convenienceFee + loungeCost + insuranceCost;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fare Breakdown & Add-ons', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fare Summary Card
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
                  Text(
                    '${booking.selectedTrain?.trainName ?? "Express"} (${booking.selectedClass})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text('$passengersCount Passenger(s) • ${booking.isTatkal ? "Tatkal Quota" : "General Quota"}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const Divider(height: 24),
                  _FareRow(title: 'Base Ticket Fare', amount: '₹${baseFare.toStringAsFixed(2)}'),
                  if (booking.isTatkal)
                    _FareRow(title: 'Tatkal Premium Charge', amount: '₹${tatkalCharge.toStringAsFixed(2)}', highlight: true),
                  _FareRow(title: 'GST & Railway Surcharge (5%)', amount: '₹${gst.toStringAsFixed(2)}'),
                  _FareRow(title: 'IRCTC Convenience Fee', amount: '₹${convenienceFee.toStringAsFixed(2)}'),
                  if (_includeLounge)
                    _FareRow(title: 'Executive Station Lounge Access', amount: '₹${loungeCost.toStringAsFixed(2)}', highlight: true),
                  if (_includeTravelInsurance)
                    _FareRow(title: 'Travel Insurance (₹10L Cover)', amount: '₹${insuranceCost.toStringAsFixed(2)}'),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Payable', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      Text('₹${grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryBlue)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Add-ons Card
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
                  const Text('PREMIUM TRAVEL ADD-ONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Executive Lounge Access', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    subtitle: const Text('Complimentary buffet, AC lounge, high-speed WiFi at source station. (₹250/person)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    value: _includeLounge,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (v) => setState(() => _includeLounge = v),
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Comprehensive Travel Insurance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    subtitle: const Text('₹10,00,000 emergency accident coverage by IRCTC. (₹0.45/person)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    value: _includeTravelInsurance,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (v) => setState(() => _includeTravelInsurance = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Cancellation Refund Info Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: AppColors.seatAvailable, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Guaranteed Instant Cancellation Refund to source account within 24h as per IRCTC refund rules.',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Proceed to Payment (₹${grandTotal.toStringAsFixed(0)})',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool highlight;

  const _FareRow({required this.title, required this.amount, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 13, color: highlight ? AppColors.accentOrange : AppColors.textSecondary, fontWeight: highlight ? FontWeight.w700 : FontWeight.w500)),
          Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: highlight ? AppColors.accentOrange : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

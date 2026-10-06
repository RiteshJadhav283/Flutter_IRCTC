import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/constants.dart';
import 'booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final fare = booking.fareDetails;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment & Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.accentOrange),
                  const SizedBox(height: 20),
                  const Text(
                    'Connecting to IRCTC Gateway...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Reserving your selected berths. Do not press back.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fare Breakdown Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight, width: 1.2),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'FARE BREAKDOWN',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryBlue, letterSpacing: 0.5),
                            ),
                            Text(
                              '${booking.passengers.length} Passenger(s)',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildFareRow('Base Ticket Fare', '₹${fare.baseFare.toInt()}'),
                        if (fare.tatkalCharge > 0)
                          _buildFareRow('Tatkal Premium Charges', '₹${fare.tatkalCharge.toInt()}'),
                        if (booking.addLounge)
                          _buildFareRow('Executive Lounge Access', '₹${(350 * booking.passengers.length).toInt()}'),
                        if (booking.travelInsurance)
                          _buildFareRow('IRCTC Travel Insurance', '₹${(0.45 * booking.passengers.length).toStringAsFixed(2)}'),
                        _buildFareRow('GST (5%)', '₹${fare.serviceTax.toStringAsFixed(2)}'),
                        _buildFareRow('IRCTC Convenience Fee', '₹${fare.convenienceFee.toInt()}'),
                        const Divider(height: 20, color: AppColors.borderLight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Payable',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                            Text(
                              '₹${fare.totalFare.toInt()}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.accentOrange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment Options
                  const Text(
                    'SELECT PAYMENT METHOD',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 10),

                  // UPI
                  _buildPaymentOption(
                    title: 'UPI (Instant & Zero Surcharge)',
                    subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
                    icon: Icons.qr_code_scanner_rounded,
                    methodKey: 'UPI',
                    tag: 'RECOMMENDED',
                  ),

                  const SizedBox(height: 10),

                  // Credit / Debit Cards
                  _buildPaymentOption(
                    title: 'Credit / Debit Cards',
                    subtitle: 'Visa, MasterCard, RuPay, Maestro',
                    icon: Icons.credit_card_rounded,
                    methodKey: 'CARD',
                  ),

                  const SizedBox(height: 10),

                  // Net Banking
                  _buildPaymentOption(
                    title: 'Net Banking',
                    subtitle: 'SBI, HDFC, ICICI, Axis & 50+ Banks',
                    icon: Icons.account_balance_rounded,
                    methodKey: 'NETBANKING',
                  ),

                  const SizedBox(height: 10),

                  // Wallets
                  _buildPaymentOption(
                    title: 'Wallets & IRCTC iMudra',
                    subtitle: 'Paytm Wallet, Amazon Pay, Mobikwik',
                    icon: Icons.account_balance_wallet_rounded,
                    methodKey: 'WALLET',
                  ),

                  const SizedBox(height: 24),

                  // Security Badge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.lock_rounded, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Text(
                          '256-bit SSL Encrypted • Official IRCTC Partner Payment',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pay Button
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });

                      await Future.delayed(const Duration(milliseconds: 1200));

                      final confirmedBooking = await booking.confirmBooking(paymentMethod: _selectedMethod);

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BookingConfirmationScreen(booking: confirmedBooking),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: AppColors.accentOrange.withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Pay ₹${fare.totalFare.toInt()} Securely',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildFareRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String methodKey,
    String? tag,
  }) {
    final isSelected = _selectedMethod == methodKey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = methodKey;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accentOrange : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentOrange.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orangeLight : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? AppColors.accentOrange : AppColors.textPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.statusAvailableBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.statusAvailable),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Radio<String>(
              value: methodKey,
              groupValue: _selectedMethod,
              onChanged: (val) {
                if (val != null) setState(() => _selectedMethod = val);
              },
              activeColor: AppColors.accentOrange,
            ),
          ],
        ),
      ),
    );
  }
}

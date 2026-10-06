import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/passenger_model.dart';
import '../../utils/constants.dart';
import 'payment_screen.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final auth = context.watch<AuthProvider>();
    final passengers = booking.passengers;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Passenger Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IRCTC User ID Verification Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, color: AppColors.primaryBlue, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'IRCTC User ID',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                          Text(
                            auth.user?.irctcUserId ?? 'RITESH_J2026',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Verified',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.statusAvailable),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Saved Passengers Quick Select
              if (auth.user?.savedPassengers.isNotEmpty ?? false) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SAVED PASSENGERS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
                    ),
                    Text(
                      'Tap to add',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withOpacity(0.8)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: auth.user!.savedPassengers.length,
                    itemBuilder: (ctx, i) {
                      final sp = auth.user!.savedPassengers[i];
                      final isAdded = passengers.any((p) => p.name == sp.name);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          avatar: Icon(
                            isAdded ? Icons.check_circle : Icons.person_add_rounded,
                            size: 16,
                            color: isAdded ? AppColors.statusAvailable : AppColors.primaryBlue,
                          ),
                          label: Text(
                            '${sp.name} (${sp.age})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isAdded ? AppColors.statusAvailable : AppColors.textPrimary,
                            ),
                          ),
                          backgroundColor: isAdded ? AppColors.statusAvailableBg : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isAdded ? AppColors.statusAvailable : AppColors.divider,
                            ),
                          ),
                          onPressed: () {
                            if (!isAdded) {
                              booking.addPassenger(
                                Passenger(
                                  id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                                  name: sp.name,
                                  age: sp.age,
                                  gender: sp.gender,
                                  berthPreference: sp.berthPreference,
                                  idProofType: sp.idType,
                                  idProofNumber: sp.idNumber,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Passengers Cards
              ...passengers.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                          Text(
                            'PASSENGER ${idx + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (passengers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.statusRegret, size: 20),
                              onPressed: () => booking.removePassenger(idx),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Name Field
                      TextFormField(
                        initialValue: p.name,
                        decoration: const InputDecoration(
                          labelText: 'Full Name (as per Govt ID)',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        onChanged: (val) {
                          // update passenger name
                        },
                      ),

                      const SizedBox(height: 12),

                      // Age and Gender Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: '${p.age}',
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                prefixIcon: Icon(Icons.cake_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: p.gender,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(Icons.wc_outlined),
                              ),
                              items: ['Male', 'Female', 'Transgender'].map((g) {
                                return DropdownMenuItem(value: g, child: Text(g));
                              }).toList(),
                              onChanged: (val) {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Berth Preference
                      DropdownButtonFormField<String>(
                        value: p.berthPreference,
                        decoration: const InputDecoration(
                          labelText: 'Berth Preference',
                          prefixIcon: Icon(Icons.airline_seat_recline_extra_outlined),
                        ),
                        items: [
                          'No Preference',
                          'Lower Berth (LB)',
                          'Middle Berth (MB)',
                          'Upper Berth (UB)',
                          'Side Lower (SL)',
                          'Side Upper (SU)',
                        ].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                        onChanged: (val) {},
                      ),

                      const SizedBox(height: 12),

                      // Food Preference
                      DropdownButtonFormField<String>(
                        value: p.foodPreference ?? 'Veg',
                        decoration: const InputDecoration(
                          labelText: 'Meal Choice',
                          prefixIcon: Icon(Icons.restaurant_menu_outlined),
                        ),
                        items: ['Veg', 'Non-Veg', 'Jain Meal', 'No Food'].map((m) {
                          return DropdownMenuItem(value: m, child: Text(m));
                        }).toList(),
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                );
              }),

              // Add Passenger Button
              OutlinedButton.icon(
                onPressed: () {
                  booking.addPassenger(
                    Passenger(
                      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                      name: '',
                      age: 25,
                      gender: 'Male',
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Another Passenger'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              // Travel Add-ons (Lounge + Insurance)
              const Text(
                'TRAVEL ADD-ONS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),

              // Lounge Access
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: SwitchListTile(
                  title: const Text('IRCTC Executive Lounge', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('Buffet meal, WiFi & AC lounge access at NDLS (₹350/person)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  value: booking.addLounge,
                  onChanged: (val) => booking.toggleLounge(val),
                  activeColor: AppColors.accentOrange,
                ),
              ),

              const SizedBox(height: 10),

              // Travel Insurance
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: SwitchListTile(
                  title: const Text('Travel Insurance Cover', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('₹10,00,000 cover against accidental loss (₹0.45/person)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  value: booking.travelInsurance,
                  onChanged: (val) => booking.toggleInsurance(val),
                  activeColor: AppColors.statusAvailable,
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('PAYABLE AMOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  Text(
                    '₹${booking.fareDetails.totalFare.toInt()}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
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
                        builder: (ctx) => const PaymentScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Proceed to Payment'),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

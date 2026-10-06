import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/pnr_provider.dart';
import '../../utils/constants.dart';

class PNRStatusScreen extends StatefulWidget {
  const PNRStatusScreen({super.key});

  @override
  State<PNRStatusScreen> createState() => _PNRStatusScreenState();
}

class _PNRStatusScreenState extends State<PNRStatusScreen> {
  final TextEditingController _pnrCtrl = TextEditingController(text: '284-9182741');

  @override
  void dispose() {
    _pnrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pnrProvider = context.watch<PNRProvider>();
    final pnrStatus = pnrProvider.currentStatus;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PNR Enquiry & Live Status', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PNR Input Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
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
                  const Text(
                    'ENTER 10-DIGIT PNR NUMBER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHint,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pnrCtrl,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2),
                    decoration: InputDecoration(
                      hintText: 'e.g. 284-9182741',
                      prefixIcon: const Icon(Icons.confirmation_number_outlined, color: AppColors.primaryBlue),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.primaryBlue),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Scanning ticket QR code...'), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () {
                      pnrProvider.searchPNR(_pnrCtrl.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: pnrProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Check Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, size: 16),
                            ],
                          ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.05, end: 0),

            const SizedBox(height: 16),

            // Recent Searches
            if (pnrProvider.recentSearches.isNotEmpty) ...[
              const Text(
                'RECENT PNR SEARCHES',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: pnrProvider.recentSearches.map((pnr) {
                  return ActionChip(
                    avatar: const Icon(Icons.history, size: 14, color: AppColors.primaryBlue),
                    label: Text(pnr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.borderLight),
                    ),
                    onPressed: () {
                      _pnrCtrl.text = pnr;
                      pnrProvider.searchPNR(pnr);
                    },
                  );
                }).toList(),
              )
                  .animate()
                  .fadeIn(duration: 350.ms),
              const SizedBox(height: 20),
            ],

            // PNR Result Display
            if (pnrStatus != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight, width: 1.2),
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
                        Text(
                          '${pnrStatus.trainNumber} ${pnrStatus.trainName}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryBlue),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: pnrStatus.chartPrepared ? AppColors.statusAvailableBg : AppColors.statusWaitlistBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            pnrStatus.chartPrepared ? 'Chart Prepared' : 'Chart Not Prepared',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: pnrStatus.chartPrepared ? AppColors.statusAvailable : AppColors.statusWaitlist,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${pnrStatus.source} → ${pnrStatus.destination} • Class: ${pnrStatus.travelClass}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 24, color: AppColors.borderLight),

                    // Live Running Radar Pulse Indicator
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
                        Expanded(
                          child: Text(
                            pnrStatus.currentStation ?? 'On-Time • Approaching Next Station',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Passenger Details Table
                    const Text(
                      'PASSENGER STATUS DETAILS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textHint, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: pnrStatus.passengers.map((p) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passenger #${p.serialNo}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Booking: ${p.bookingStatus}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primaryBlue),
                                ),
                                child: Text(
                                  '${p.coach ?? "B4"} - ${p.berth ?? "37"} (${p.berthType ?? "SL"})',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

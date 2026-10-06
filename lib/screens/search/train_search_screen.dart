import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/train_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/station_selector_sheet.dart';
import 'train_list_screen.dart';

class TrainSearchScreen extends StatefulWidget {
  const TrainSearchScreen({super.key});

  @override
  State<TrainSearchScreen> createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedClass = '3A';
  String _selectedQuota = 'GN';

  @override
  Widget build(BuildContext context) {
    final trainProvider = context.watch<TrainProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Trains', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Station selector box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      StationSelectorSheet.show(
                        context,
                        title: 'Select Origin Station',
                        currentStation: trainProvider.sourceStation,
                        onSelect: (station) => trainProvider.setSource(station),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.trip_origin_rounded, color: AppColors.primaryBlue, size: 22),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('FROM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(
                                '${trainProvider.sourceStation.name} (${trainProvider.sourceStation.code})',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),
                  InkWell(
                    onTap: () {
                      StationSelectorSheet.show(
                        context,
                        title: 'Select Destination Station',
                        currentStation: trainProvider.destinationStation,
                        onSelect: (station) => trainProvider.setDestination(station),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppColors.accentOrange, size: 22),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('TO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(
                                '${trainProvider.destinationStation.name} (${trainProvider.destinationStation.code})',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Date picker box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 1.2),
              ),
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 120)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                    trainProvider.setJourneyDate(picked);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: AppColors.primaryBlue),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('JOURNEY DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.5)),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Quota and Class selection
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CLASS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedClass,
                            isDense: true,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'ALL', child: Text('All Classes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: '1A', child: Text('1A (AC First)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: '2A', child: Text('2A (AC 2-Tier)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: '3A', child: Text('3A (AC 3-Tier)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: 'SL', child: Text('SL (Sleeper)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: '2S', child: Text('2S (Second Sitting)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedClass = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('QUOTA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedQuota,
                            isDense: true,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'GN', child: Text('General (GN)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: 'TQ', child: Text('Tatkal (TQ)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: 'PT', child: Text('Premium Tatkal (PT)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: 'LD', child: Text('Ladies (LD)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                              DropdownMenuItem(value: 'SS', child: Text('Sr. Citizen (SS)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedQuota = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Search Trains',
              icon: Icons.search_rounded,
              onPressed: () {
                trainProvider.searchTrains();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

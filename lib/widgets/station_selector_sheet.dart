import 'package:flutter/material.dart';
import '../models/station_model.dart';
import '../services/mock_data.dart';
import '../utils/constants.dart';

class StationSelectorSheet extends StatefulWidget {
  final String title;
  final Station currentStation;
  final Function(Station selected) onSelect;

  const StationSelectorSheet({
    super.key,
    required this.title,
    required this.currentStation,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Station currentStation,
    required Function(Station) onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StationSelectorSheet(
        title: title,
        currentStation: currentStation,
        onSelect: onSelect,
      ),
    );
  }

  @override
  State<StationSelectorSheet> createState() => _StationSelectorSheetState();
}

class _StationSelectorSheetState extends State<StationSelectorSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Station> _filteredStations = MockData.stations;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStations = MockData.stations;
      } else {
        _filteredStations = MockData.stations.where((s) {
          return s.code.toLowerCase().contains(query) ||
              s.name.toLowerCase().contains(query) ||
              s.city.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: TextField(
              controller: _searchCtrl,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search station by name, code or city...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryBlue),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Popular Quick Stations Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'POPULAR METRO STATIONS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary.withOpacity(0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _quickStationChip('NDLS', 'New Delhi'),
                _quickStationChip('MMCT', 'Mumbai Central'),
                _quickStationChip('CSMT', 'Mumbai CSMT'),
                _quickStationChip('HWH', 'Howrah'),
                _quickStationChip('PNBE', 'Patna'),
                _quickStationChip('MAS', 'Chennai'),
                _quickStationChip('SBC', 'Bengaluru'),
              ],
            ),
          ),

          const Divider(height: 24, thickness: 1, color: AppColors.borderLight),

          // Stations List
          Expanded(
            child: _filteredStations.isEmpty
                ? const Center(
                    child: Text(
                      'No matching stations found',
                      style: TextStyle(color: AppColors.textHint, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredStations.length,
                    itemBuilder: (ctx, i) {
                      final s = _filteredStations[i];
                      final isSelected = s.code == widget.currentStation.code;

                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            widget.onSelect(s);
                            Navigator.pop(context);
                          },
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryBlue : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              s.code,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : AppColors.primaryBlue,
                              ),
                            ),
                          ),
                          title: Text(
                            s.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            '${s.city}, ${s.state}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: AppColors.primaryBlue)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _quickStationChip(String code, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(
          '$code • $name',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.divider),
        ),
        onPressed: () {
          final found = MockData.stations.firstWhere(
            (s) => s.code == code,
            orElse: () => Station(code: code, name: name, city: name, state: ''),
          );
          widget.onSelect(found);
          Navigator.pop(context);
        },
      ),
    );
  }
}

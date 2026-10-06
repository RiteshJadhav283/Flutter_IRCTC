import 'package:flutter/foundation.dart';
import '../models/pnr_model.dart';
import '../services/mock_data.dart';

class PNRProvider extends ChangeNotifier {
  String _currentQuery = '';
  PNRStatus? _currentStatus = MockData.pnrDatabase['284-9182741'];
  bool _isLoading = false;
  String? _errorMessage;
  final List<String> _recentSearches = ['284-9182741', '642-1084920', '812-4091823'];

  String get currentQuery => _currentQuery;
  PNRStatus? get currentStatus => _currentStatus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get recentSearches => _recentSearches;

  Future<void> searchPNR(String pnr) async {
    final clean = pnr.trim();
    if (clean.isEmpty) return;

    _currentQuery = clean;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (MockData.pnrDatabase.containsKey(clean)) {
      _currentStatus = MockData.pnrDatabase[clean];
      if (!_recentSearches.contains(clean)) {
        _recentSearches.insert(0, clean);
      }
    } else {
      // Create a simulated live status for any entered 10-digit PNR
      _currentStatus = PNRStatus(
        pnr: clean,
        trainNumber: '12952',
        trainName: 'Mumbai Rajdhani Express',
        source: 'NDLS',
        destination: 'MMCT',
        journeyDate: DateTime.now().add(const Duration(days: 1)),
        travelClass: '3A',
        quota: 'General',
        chartPrepared: true,
        currentStation: 'Passed Mathura Jn (On Time)',
        delayMinutes: 0,
        expectedPlatform: 3,
        passengers: const [
          PassengerPNRStatus(
            serialNo: 1,
            bookingStatus: 'CNF',
            currentStatus: 'CNF',
            coach: 'B4',
            berth: '37',
            berthType: 'Side Lower (SL)',
          ),
        ],
      );
      if (!_recentSearches.contains(clean)) {
        _recentSearches.insert(0, clean);
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}

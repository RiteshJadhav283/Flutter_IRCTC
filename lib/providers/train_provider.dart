import 'package:flutter/foundation.dart';
import '../models/station_model.dart';
import '../models/train_model.dart';
import '../services/mock_data.dart';

class TrainProvider extends ChangeNotifier {
  Station _source = MockData.stations[0]; // NDLS
  Station _destination = MockData.stations[1]; // MMCT
  DateTime _journeyDate = DateTime.now().add(const Duration(days: 1));
  String _selectedClass = 'ALL';
  String _selectedQuota = 'General';
  bool _isSearching = false;
  List<Train> _searchResults = MockData.trains;
  Train? _selectedTrain;
  bool _availableOnly = false;
  String _sortBy = 'departure'; // 'departure', 'duration', 'price'

  Station get source => _source;
  Station get destination => _destination;
  Station get sourceStation => _source;
  Station get destinationStation => _destination;
  DateTime get journeyDate => _journeyDate;
  String get selectedClass => _selectedClass;
  String get selectedQuota => _selectedQuota;
  bool get isSearching => _isSearching;
  Train? get selectedTrain => _selectedTrain;
  bool get availableOnly => _availableOnly;
  String get sortBy => _sortBy;

  List<Train> get searchResults {
    List<Train> filtered = List.from(_searchResults);

    if (_availableOnly) {
      filtered = filtered.where((t) {
        return t.classes.values.any((c) => c.status == 'AVAILABLE' && c.availableSeats > 0);
      }).toList();
    }

    if (_selectedClass != 'ALL') {
      filtered = filtered.where((t) => t.classes.containsKey(_selectedClass)).toList();
    }

    if (_sortBy == 'departure') {
      filtered.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    } else if (_sortBy == 'duration') {
      filtered.sort((a, b) => a.duration.compareTo(b.duration));
    }

    return filtered;
  }

  void setSource(Station station) {
    _source = station;
    notifyListeners();
  }

  void setDestination(Station station) {
    _destination = station;
    notifyListeners();
  }

  void swapStations() {
    final temp = _source;
    _source = _destination;
    _destination = temp;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _journeyDate = date;
    notifyListeners();
  }

  void setJourneyDate(DateTime date) {
    _journeyDate = date;
    notifyListeners();
  }

  void setSelectedClass(String classCode) {
    _selectedClass = classCode;
    notifyListeners();
  }

  void setSelectedQuota(String quota) {
    _selectedQuota = quota;
    notifyListeners();
  }

  void toggleAvailableOnly() {
    _availableOnly = !_availableOnly;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void selectTrain(Train train) {
    _selectedTrain = train;
    notifyListeners();
  }

  List<Station> getStationSuggestions(String query) {
    if (query.trim().isEmpty) return MockData.stations;
    final lower = query.toLowerCase();
    return MockData.stations.where((s) {
      return s.code.toLowerCase().contains(lower) ||
          s.name.toLowerCase().contains(lower) ||
          s.city.toLowerCase().contains(lower);
    }).toList();
  }

  Future<void> searchTrains() async {
    _isSearching = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    // Filter matching trains
    final matches = MockData.trains.where((t) {
      final matchSource = t.source.toLowerCase() == _source.code.toLowerCase() ||
          t.sourceName.toLowerCase().contains(_source.city.toLowerCase());
      final matchDest = t.destination.toLowerCase() == _destination.code.toLowerCase() ||
          t.destinationName.toLowerCase().contains(_destination.city.toLowerCase());
      return matchSource || matchDest;
    }).toList();

    _searchResults = matches.isNotEmpty ? matches : MockData.trains;
    _isSearching = false;
    notifyListeners();
  }
}

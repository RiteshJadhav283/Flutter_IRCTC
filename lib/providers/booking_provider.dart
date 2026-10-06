import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/train_model.dart';
import '../models/passenger_model.dart';
import '../models/booking_model.dart';
import '../utils/constants.dart';
import '../services/mock_data.dart';

class BookingProvider extends ChangeNotifier {
  Train? _train;
  String _selectedClass = '3A';
  String _selectedCoach = 'B4';
  DateTime _journeyDate = DateTime.now().add(const Duration(days: 1));
  String _quota = 'General';
  bool _isTatkal = false;
  bool _addLounge = false;
  bool _travelInsurance = true;

  // Selected Berths in coach: berthNumber -> berthType
  final Map<int, String> _selectedBerths = {37: 'SL'};

  // Current list of passengers filling details
  final List<Passenger> _passengers = [
    Passenger(
      id: 'p_1',
      name: 'Ritesh Jadhav',
      age: 21,
      gender: 'Male',
      berthPreference: 'Side Lower (SL)',
      foodPreference: 'Veg',
      idProofType: 'Aadhaar Card',
      idProofNumber: 'XXXX-XXXX-8921',
      coachNumber: 'B4',
      berthNumber: '37',
      berthType: 'Side Lower (SL)',
    ),
  ];

  // User's bookings
  final List<Booking> _bookings = List.from(MockData.defaultBookings);
  Booking? _lastConfirmedBooking;

  Train? get train => _train;
  String get selectedClass => _selectedClass;
  String get selectedCoach => _selectedCoach;
  DateTime get journeyDate => _journeyDate;
  String get quota => _quota;
  bool get isTatkal => _isTatkal;
  bool get addLounge => _addLounge;
  bool get travelInsurance => _travelInsurance;
  Map<int, String> get selectedBerths => _selectedBerths;
  List<Passenger> get passengers => _passengers;
  List<Booking> get bookings => _bookings;
  Booking? get lastConfirmedBooking => _lastConfirmedBooking;

  void startBookingFlow({
    required Train train,
    required String travelClass,
    required DateTime date,
    String quota = 'General',
  }) {
    _train = train;
    _selectedClass = travelClass;
    _journeyDate = date;
    _quota = quota;
    _isTatkal = quota == 'Tatkal';
    _selectedCoach = travelClass == '3A' ? 'B4' : (travelClass == '2A' ? 'A1' : 'S1');
    _selectedBerths.clear();
    _selectedBerths[37] = 'SL';
    notifyListeners();
  }

  void selectCoach(String coach) {
    _selectedCoach = coach;
    notifyListeners();
  }

  void toggleBerth(int berthNumber, String berthType) {
    if (_selectedBerths.containsKey(berthNumber)) {
      _selectedBerths.remove(berthNumber);
    } else {
      if (_selectedBerths.length < 6) {
        _selectedBerths[berthNumber] = berthType;
      }
    }
    notifyListeners();
  }

  void addPassenger(Passenger passenger) {
    _passengers.add(passenger);
    notifyListeners();
  }

  void removePassenger(int index) {
    if (index >= 0 && index < _passengers.length) {
      _passengers.removeAt(index);
      notifyListeners();
    }
  }

  void setTatkal(bool value) {
    _isTatkal = value;
    _quota = value ? 'Tatkal' : 'General';
    notifyListeners();
  }

  void toggleLounge(bool value) {
    _addLounge = value;
    notifyListeners();
  }

  void toggleInsurance(bool value) {
    _travelInsurance = value;
    notifyListeners();
  }

  FareDetails get fareDetails {
    final count = max(1, _passengers.length);
    double basePerSeat = AppConstants.baseFares[_selectedClass] ?? 850.0;
    if (_train != null && _train!.classes.containsKey(_selectedClass)) {
      basePerSeat = _train!.classes[_selectedClass]!.price;
    }

    final baseFare = basePerSeat * count;
    final tatkalCharge = _isTatkal ? ((AppConstants.tatkalCharges[_selectedClass] ?? 300.0) * count) : 0.0;
    final loungeCharge = _addLounge ? (350.0 * count) : 0.0;
    final insuranceCharge = _travelInsurance ? (0.45 * count) : 0.0;
    final serviceTax = (baseFare + tatkalCharge + loungeCharge) * AppConstants.gstRate;
    const convenienceFee = AppConstants.convenienceFee;
    final totalFare = baseFare + tatkalCharge + loungeCharge + insuranceCharge + serviceTax + convenienceFee;

    return FareDetails(
      baseFare: baseFare,
      tatkalCharge: tatkalCharge,
      serviceTax: serviceTax,
      convenienceFee: convenienceFee,
      totalFare: totalFare,
    );
  }

  Future<Booking> confirmBooking({required String paymentMethod}) async {
    final randomPNR = '${Random().nextInt(899) + 100}-${Random().nextInt(8999999) + 1000000}';
    final randomTxn = 'RGO-TXN-${Random().nextInt(8999999) + 1000000}';

    // Assign coach and berth to passengers
    final assignedPassengers = <Passenger>[];
    int idx = 0;
    final berthKeys = _selectedBerths.keys.toList();

    for (final p in _passengers) {
      final berthNo = idx < berthKeys.length ? berthKeys[idx] : (30 + idx);
      final bType = idx < berthKeys.length ? _selectedBerths[berthNo] ?? 'SL' : 'LB';
      assignedPassengers.add(Passenger(
        id: p.id,
        name: p.name,
        age: p.age,
        gender: p.gender,
        berthPreference: p.berthPreference,
        foodPreference: p.foodPreference,
        idProofType: p.idProofType,
        idProofNumber: p.idProofNumber,
        currentStatus: 'CNF',
        coachNumber: _selectedCoach,
        berthNumber: '$berthNo',
        berthType: bType,
      ));
      idx++;
    }

    final newBooking = Booking(
      pnr: randomPNR,
      userId: 'user_ritesh_01',
      trainNumber: _train?.trainNumber ?? '12952',
      trainName: _train?.trainName ?? 'Mumbai Rajdhani Express',
      trainType: _train?.trainType ?? 'Superfast AC Special',
      journeyDate: _journeyDate,
      bookingDate: DateTime.now(),
      source: _train?.source ?? 'NDLS',
      sourceName: _train?.sourceName ?? 'New Delhi',
      destination: _train?.destination ?? 'MMCT',
      destinationName: _train?.destinationName ?? 'Mumbai Central',
      departureTime: _train?.departureTime ?? '16:55',
      arrivalTime: _train?.arrivalTime ?? '08:35',
      departurePlatform: _train?.departurePlatform ?? 3,
      arrivalPlatform: _train?.arrivalPlatform ?? 1,
      travelClass: _selectedClass,
      quota: _quota,
      status: 'CONFIRMED',
      isTatkal: _isTatkal,
      passengers: assignedPassengers,
      fareDetails: fareDetails,
      paymentMethod: paymentMethod,
      transactionId: randomTxn,
      isDownloaded: true,
    );

    _bookings.insert(0, newBooking);
    _lastConfirmedBooking = newBooking;
    notifyListeners();
    return newBooking;
  }

  void cancelBooking(String pnr) {
    final index = _bookings.indexWhere((b) => b.pnr == pnr);
    if (index != -1) {
      final b = _bookings[index];
      final updated = Booking(
        pnr: b.pnr,
        userId: b.userId,
        trainNumber: b.trainNumber,
        trainName: b.trainName,
        trainType: b.trainType,
        journeyDate: b.journeyDate,
        bookingDate: b.bookingDate,
        source: b.source,
        sourceName: b.sourceName,
        destination: b.destination,
        destinationName: b.destinationName,
        departureTime: b.departureTime,
        arrivalTime: b.arrivalTime,
        travelClass: b.travelClass,
        quota: b.quota,
        status: 'CANCELLED',
        isTatkal: b.isTatkal,
        passengers: b.passengers,
        fareDetails: b.fareDetails,
        paymentMethod: b.paymentMethod,
        transactionId: b.transactionId,
        isDownloaded: b.isDownloaded,
      );
      _bookings[index] = updated;
      notifyListeners();
    }
  }

  void toggleDownloaded(String pnr) {
    final index = _bookings.indexWhere((b) => b.pnr == pnr);
    if (index != -1) {
      _bookings[index].isDownloaded = !_bookings[index].isDownloaded;
      notifyListeners();
    }
  }
}

class PassengerPNRStatus {
  final int serialNo;
  final String bookingStatus; // "CNF", "WL 12", "RAC 4"
  final String currentStatus; // "CNF", "WL 2", "RAC 1"
  final String? coach;
  final String? berth;
  final String? berthType;

  const PassengerPNRStatus({
    required this.serialNo,
    required this.bookingStatus,
    required this.currentStatus,
    this.coach,
    this.berth,
    this.berthType,
  });

  factory PassengerPNRStatus.fromJson(Map<String, dynamic> json) {
    return PassengerPNRStatus(
      serialNo: json['serialNo'] ?? 1,
      bookingStatus: json['bookingStatus'] ?? 'CNF',
      currentStatus: json['currentStatus'] ?? 'CNF',
      coach: json['coach'],
      berth: json['berth'],
      berthType: json['berthType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'serialNo': serialNo,
    'bookingStatus': bookingStatus,
    'currentStatus': currentStatus,
    'coach': coach,
    'berth': berth,
    'berthType': berthType,
  };
}

class PNRStatus {
  final String pnr;
  final String trainNumber;
  final String trainName;
  final String source;
  final String destination;
  final DateTime journeyDate;
  final String travelClass;
  final String quota;
  final bool chartPrepared;
  final List<PassengerPNRStatus> passengers;
  final String? currentStation;
  final int delayMinutes;
  final int expectedPlatform;

  const PNRStatus({
    required this.pnr,
    required this.trainNumber,
    required this.trainName,
    required this.source,
    required this.destination,
    required this.journeyDate,
    required this.travelClass,
    this.quota = 'General',
    this.chartPrepared = false,
    required this.passengers,
    this.currentStation,
    this.delayMinutes = 0,
    this.expectedPlatform = 1,
  });

  factory PNRStatus.fromJson(Map<String, dynamic> json) {
    return PNRStatus(
      pnr: json['pnr'] ?? '',
      trainNumber: json['trainNumber'] ?? '',
      trainName: json['trainName'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',
      journeyDate: DateTime.tryParse(json['journeyDate'] ?? '') ?? DateTime.now(),
      travelClass: json['travelClass'] ?? '3A',
      quota: json['quota'] ?? 'General',
      chartPrepared: json['chartPrepared'] ?? false,
      passengers: (json['passengers'] as List? ?? [])
          .map((p) => PassengerPNRStatus.fromJson(p as Map<String, dynamic>))
          .toList(),
      currentStation: json['currentStation'],
      delayMinutes: json['delayMinutes'] ?? 0,
      expectedPlatform: json['expectedPlatform'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'pnr': pnr,
    'trainNumber': trainNumber,
    'trainName': trainName,
    'source': source,
    'destination': destination,
    'journeyDate': journeyDate.toIso8601String(),
    'travelClass': travelClass,
    'quota': quota,
    'chartPrepared': chartPrepared,
    'passengers': passengers.map((p) => p.toJson()).toList(),
    'currentStation': currentStation,
    'delayMinutes': delayMinutes,
    'expectedPlatform': expectedPlatform,
  };
}

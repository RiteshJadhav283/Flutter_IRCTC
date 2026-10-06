import 'passenger_model.dart';

class FareDetails {
  final double baseFare;
  final double tatkalCharge;
  final double serviceTax;
  final double convenienceFee;
  final double totalFare;

  const FareDetails({
    required this.baseFare,
    required this.tatkalCharge,
    required this.serviceTax,
    required this.convenienceFee,
    required this.totalFare,
  });

  factory FareDetails.fromJson(Map<String, dynamic> json) {
    return FareDetails(
      baseFare: (json['baseFare'] as num?)?.toDouble() ?? 0.0,
      tatkalCharge: (json['tatkalCharge'] as num?)?.toDouble() ?? 0.0,
      serviceTax: (json['serviceTax'] as num?)?.toDouble() ?? 0.0,
      convenienceFee: (json['convenienceFee'] as num?)?.toDouble() ?? 35.0,
      totalFare: (json['totalFare'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'baseFare': baseFare,
    'tatkalCharge': tatkalCharge,
    'serviceTax': serviceTax,
    'convenienceFee': convenienceFee,
    'totalFare': totalFare,
  };
}

class Booking {
  final String pnr;
  final String userId;
  final String trainNumber;
  final String trainName;
  final String trainType;
  final DateTime journeyDate;
  final DateTime bookingDate;
  final String source;
  final String sourceName;
  final String destination;
  final String destinationName;
  final String departureTime;
  final String arrivalTime;
  final int departurePlatform;
  final int arrivalPlatform;
  final String travelClass;
  final String quota;
  final String status; // "CONFIRMED", "WL", "RAC", "CANCELLED"
  final bool isTatkal;
  final List<Passenger> passengers;
  final FareDetails fareDetails;
  final String paymentMethod;
  final String transactionId;
  bool isDownloaded;

  Booking({
    required this.pnr,
    required this.userId,
    required this.trainNumber,
    required this.trainName,
    this.trainType = 'Superfast Express',
    required this.journeyDate,
    required this.bookingDate,
    required this.source,
    required this.sourceName,
    required this.destination,
    required this.destinationName,
    required this.departureTime,
    required this.arrivalTime,
    this.departurePlatform = 3,
    this.arrivalPlatform = 1,
    required this.travelClass,
    this.quota = 'General',
    this.status = 'CONFIRMED',
    this.isTatkal = false,
    required this.passengers,
    required this.fareDetails,
    this.paymentMethod = 'UPI',
    required this.transactionId,
    this.isDownloaded = false,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      pnr: json['pnr'] ?? '',
      userId: json['userId'] ?? '',
      trainNumber: json['trainNumber'] ?? '',
      trainName: json['trainName'] ?? '',
      trainType: json['trainType'] ?? 'Superfast Express',
      journeyDate: DateTime.tryParse(json['journeyDate'] ?? '') ?? DateTime.now(),
      bookingDate: DateTime.tryParse(json['bookingDate'] ?? '') ?? DateTime.now(),
      source: json['source'] ?? '',
      sourceName: json['sourceName'] ?? json['source'] ?? '',
      destination: json['destination'] ?? '',
      destinationName: json['destinationName'] ?? json['destination'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      departurePlatform: json['departurePlatform'] ?? 3,
      arrivalPlatform: json['arrivalPlatform'] ?? 1,
      travelClass: json['travelClass'] ?? '3A',
      quota: json['quota'] ?? 'General',
      status: json['status'] ?? 'CONFIRMED',
      isTatkal: json['isTatkal'] ?? false,
      passengers: (json['passengers'] as List? ?? [])
          .map((p) => Passenger.fromJson(p as Map<String, dynamic>))
          .toList(),
      fareDetails: FareDetails.fromJson(json['fareDetails'] ?? {}),
      paymentMethod: json['paymentMethod'] ?? 'UPI',
      transactionId: json['transactionId'] ?? '',
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'pnr': pnr,
    'userId': userId,
    'trainNumber': trainNumber,
    'trainName': trainName,
    'trainType': trainType,
    'journeyDate': journeyDate.toIso8601String(),
    'bookingDate': bookingDate.toIso8601String(),
    'source': source,
    'sourceName': sourceName,
    'destination': destination,
    'destinationName': destinationName,
    'departureTime': departureTime,
    'arrivalTime': arrivalTime,
    'departurePlatform': departurePlatform,
    'arrivalPlatform': arrivalPlatform,
    'travelClass': travelClass,
    'quota': quota,
    'status': status,
    'isTatkal': isTatkal,
    'passengers': passengers.map((p) => p.toJson()).toList(),
    'fareDetails': fareDetails.toJson(),
    'paymentMethod': paymentMethod,
    'transactionId': transactionId,
    'isDownloaded': isDownloaded,
  };
}

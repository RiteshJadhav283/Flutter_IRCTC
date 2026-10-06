class TrainStop {
  final String stationCode;
  final String stationName;
  final String arrival;
  final String departure;
  final int? platform;
  final int distanceKm;

  const TrainStop({
    required this.stationCode,
    required this.stationName,
    required this.arrival,
    required this.departure,
    this.platform,
    required this.distanceKm,
  });

  factory TrainStop.fromJson(Map<String, dynamic> json) {
    return TrainStop(
      stationCode: json['stationCode'] ?? '',
      stationName: json['stationName'] ?? '',
      arrival: json['arrival'] ?? '',
      departure: json['departure'] ?? '',
      platform: json['platform'],
      distanceKm: json['distanceKm'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'stationCode': stationCode,
    'stationName': stationName,
    'arrival': arrival,
    'departure': departure,
    'platform': platform,
    'distanceKm': distanceKm,
  };
}

class ClassInfo {
  final String classCode;
  final String className;
  final int availableSeats;
  final int waitlistCount;
  final String status; // "AVAILABLE", "WL", "RAC", "REGRET"
  final double price;
  final String? confirmationChance;

  const ClassInfo({
    required this.classCode,
    required this.className,
    required this.availableSeats,
    required this.waitlistCount,
    required this.status,
    required this.price,
    this.confirmationChance,
  });

  factory ClassInfo.fromJson(String code, Map<String, dynamic> json) {
    return ClassInfo(
      classCode: code,
      className: json['className'] ?? code,
      availableSeats: json['availableSeats'] ?? 0,
      waitlistCount: json['waitlistCount'] ?? 0,
      status: json['status'] ?? 'AVAILABLE',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      confirmationChance: json['confirmationChance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'className': className,
    'availableSeats': availableSeats,
    'waitlistCount': waitlistCount,
    'status': status,
    'price': price,
    'confirmationChance': confirmationChance,
  };

  bool get isAvailable => status == 'AVAILABLE' && availableSeats > 0;
  bool get isWaitlist => status == 'WL';
  bool get isRAC => status == 'RAC';
}

class Train {
  final String trainNumber;
  final String trainName;
  final String trainType; // "Vande Bharat", "Rajdhani Express", "Superfast", "Mail"
  final String source;
  final String sourceName;
  final String destination;
  final String destinationName;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int departurePlatform;
  final int arrivalPlatform;
  final List<String> runningDays;
  final bool hasPantry;
  final bool hasFoodService;
  final double punctualityPercent;
  final Map<String, ClassInfo> classes;
  final List<TrainStop> stops;

  const Train({
    required this.trainNumber,
    required this.trainName,
    this.trainType = 'Superfast Express',
    required this.source,
    required this.sourceName,
    required this.destination,
    required this.destinationName,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    this.departurePlatform = 1,
    this.arrivalPlatform = 1,
    required this.runningDays,
    this.hasPantry = true,
    this.hasFoodService = true,
    this.punctualityPercent = 95.0,
    required this.classes,
    this.stops = const [],
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    Map<String, ClassInfo> parsedClasses = {};
    if (json['classes'] is Map) {
      (json['classes'] as Map).forEach((key, val) {
        if (val is Map<String, dynamic>) {
          parsedClasses[key.toString()] = ClassInfo.fromJson(key.toString(), val);
        }
      });
    }

    List<TrainStop> parsedStops = [];
    if (json['stops'] is List) {
      parsedStops = (json['stops'] as List)
          .map((s) => TrainStop.fromJson(s as Map<String, dynamic>))
          .toList();
    }

    return Train(
      trainNumber: json['trainNumber'] ?? '',
      trainName: json['trainName'] ?? '',
      trainType: json['trainType'] ?? 'Superfast',
      source: json['source'] ?? '',
      sourceName: json['sourceName'] ?? json['source'] ?? '',
      destination: json['destination'] ?? '',
      destinationName: json['destinationName'] ?? json['destination'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      departurePlatform: json['departurePlatform'] ?? 1,
      arrivalPlatform: json['arrivalPlatform'] ?? 1,
      runningDays: List<String>.from(json['runningDays'] ?? ['M', 'T', 'W', 'T', 'F', 'S', 'S']),
      hasPantry: json['hasPantry'] ?? true,
      hasFoodService: json['hasFoodService'] ?? true,
      punctualityPercent: (json['punctualityPercent'] as num?)?.toDouble() ?? 95.0,
      classes: parsedClasses,
      stops: parsedStops,
    );
  }

  Map<String, dynamic> toJson() => {
    'trainNumber': trainNumber,
    'trainName': trainName,
    'trainType': trainType,
    'source': source,
    'sourceName': sourceName,
    'destination': destination,
    'destinationName': destinationName,
    'departureTime': departureTime,
    'arrivalTime': arrivalTime,
    'duration': duration,
    'departurePlatform': departurePlatform,
    'arrivalPlatform': arrivalPlatform,
    'runningDays': runningDays,
    'hasPantry': hasPantry,
    'hasFoodService': hasFoodService,
    'punctualityPercent': punctualityPercent,
    'classes': classes.map((k, v) => MapEntry(k, v.toJson())),
    'stops': stops.map((s) => s.toJson()).toList(),
  };
}

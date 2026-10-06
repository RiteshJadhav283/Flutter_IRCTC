class Station {
  final String code;
  final String name;
  final String city;
  final String state;

  const Station({
    required this.code,
    required this.name,
    required this.city,
    required this.state,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      code: json['code'] ?? json['stationCode'] ?? '',
      name: json['name'] ?? json['stationName'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'city': city,
      'state': state,
    };
  }

  @override
  String toString() => '$name ($code)';
}

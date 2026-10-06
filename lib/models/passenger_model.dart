class Passenger {
  final String id;
  final String name;
  final int age;
  final String gender; // 'Male', 'Female', 'Transgender'
  final String berthPreference;
  final String? foodPreference; // 'Veg', 'Non-Veg', 'Jain Meal', 'No Food'
  final String idProofType;
  final String idProofNumber;
  String currentStatus; // 'CNF', 'RAC', 'WL'
  String? coachNumber;
  String? berthNumber;
  String? berthType;

  Passenger({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.berthPreference = 'No Preference',
    this.foodPreference = 'Veg',
    this.idProofType = 'Aadhaar Card',
    this.idProofNumber = '',
    this.currentStatus = 'CNF',
    this.coachNumber,
    this.berthNumber,
    this.berthType,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'Male',
      berthPreference: json['berthPreference'] ?? 'No Preference',
      foodPreference: json['foodPreference'] ?? 'Veg',
      idProofType: json['idProofType'] ?? 'Aadhaar Card',
      idProofNumber: json['idProofNumber'] ?? '',
      currentStatus: json['currentStatus'] ?? 'CNF',
      coachNumber: json['coachNumber'],
      berthNumber: json['berthNumber'],
      berthType: json['berthType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
    'berthPreference': berthPreference,
    'foodPreference': foodPreference,
    'idProofType': idProofType,
    'idProofNumber': idProofNumber,
    'currentStatus': currentStatus,
    'coachNumber': coachNumber,
    'berthNumber': berthNumber,
    'berthType': berthType,
  };
}

class SavedPassenger {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String berthPreference;
  final String idCardType;
  final String idCardNumber;

  String get idType => idCardType;
  String get idNumber => idCardNumber;

  const SavedPassenger({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.berthPreference = 'No Preference',
    String? idCardType,
    String? idType,
    String? idCardNumber,
    String? idNumber,
  })  : idCardType = idCardType ?? idType ?? 'Aadhaar Card',
        idCardNumber = idCardNumber ?? idNumber ?? '';


  factory SavedPassenger.fromJson(Map<String, dynamic> json) {
    return SavedPassenger(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'Male',
      berthPreference: json['berthPreference'] ?? 'No Preference',
      idCardType: json['idCardType'] ?? json['idType'] ?? 'Aadhaar Card',
      idCardNumber: json['idCardNumber'] ?? json['idNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
    'berthPreference': berthPreference,
    'idCardType': idCardType,
    'idCardNumber': idCardNumber,
  };
}

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? photoURL;
  final String? irctcUserId;
  final List<SavedPassenger> savedPassengers;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.photoURL,
    this.irctcUserId,
    this.savedPassengers = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoURL: json['photoURL'],
      irctcUserId: json['irctcUserId'],
      savedPassengers: (json['savedPassengers'] as List? ?? [])
          .map((p) => SavedPassenger.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phone': phone,
    'photoURL': photoURL,
    'irctcUserId': irctcUserId,
    'savedPassengers': savedPassengers.map((p) => p.toJson()).toList(),
  };

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoURL,
    String? irctcUserId,
    List<SavedPassenger>? savedPassengers,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoURL: photoURL ?? this.photoURL,
      irctcUserId: irctcUserId ?? this.irctcUserId,
      savedPassengers: savedPassengers ?? this.savedPassengers,
    );
  }
}

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime registrationDateTime;
  final String? email;
  final DateTime? dateOfBirth;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.registrationDateTime,
    this.email,
    this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'registrationDateTime': registrationDateTime.toIso8601String(),
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? 'user',
      registrationDateTime: map['registrationDateTime'] != null
          ? DateTime.parse(map['registrationDateTime'])
          : DateTime.now(),
      email: map['email'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'])
          : null,
    );
  }

  String get displayName => '$firstName $lastName';

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? role,
    DateTime? registrationDateTime,
    String? email,
    DateTime? dateOfBirth,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      registrationDateTime: registrationDateTime ?? this.registrationDateTime,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}


// ignore_for_file: non_constant_identifier_names

class User {
  final int id;
  final String name;
  final String email, student_id, role, phone_number, picture;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone_number,
      required this.role,
      required this.picture,
      required this.student_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['full_name'],
      email: json['email'],
      picture: json['picture'],
      phone_number: json['phone_number'],
      role: json['role'],
      student_id: json['student_id'],
    );
  }
}

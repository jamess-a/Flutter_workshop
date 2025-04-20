class Staff {
  final int id;
  final String? username;
  final String? password;
  final String? email;
  final int? age;
  final int? height;
  final String? phone;
  final String? uid;
  final String? roleName;

  Staff({
    required this.id,
    this.username,
    this.password,
    this.email,
    this.age,
    this.height,
    this.phone,
    this.uid,
    this.roleName,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'], // Field id
      username: json['username'], // Field username
      password: json['password'], // Field password
      email: json['email'], // Field email
      age: json['age'], // Field age
      height: json['height'], // Field height
      phone: json['phone'], // Field phone
      uid: json['uid'], // Field uid
      roleName: json['role_name'], // Field role_name
    );
  }

  @override
  String toString() {
    return 'Staff(id: $id, username: $username, email: $email, roleName: $roleName)';
  }
}
